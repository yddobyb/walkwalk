/**
 * All Image Generation APIs Test
 * Tests all 4 APIs in sequence and provides a summary
 */

import 'dotenv/config';
import fs from 'fs';
import Replicate from 'replicate';
import { fal } from '@fal-ai/client';
import OpenAI from 'openai';

const TEST_PROMPT = "A cute cartoon dog sticker with a happy expression, wearing a red collar, simple flat design, white background";

// Configure clients
const replicate = new Replicate({
  auth: process.env.REPLICATE_API_TOKEN,
});

fal.config({
  credentials: process.env.FAL_KEY
});

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Create output directory
if (!fs.existsSync('output')) {
  fs.mkdirSync('output');
}

// Test functions
async function testPixazo() {
  const startTime = Date.now();
  try {
    const response = await fetch('https://gateway.pixazo.ai/flux-1-schnell/v1/getData', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': process.env.PIXAZO_API_KEY
      },
      body: JSON.stringify({
        prompt: TEST_PROMPT,
        num_steps: 4,
        height: 1024,
        width: 1024
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }

    const data = await response.json();
    const elapsed = Date.now() - startTime;

    if (data.output) {
      const imageResponse = await fetch(data.output);
      const imageBuffer = await imageResponse.arrayBuffer();
      fs.writeFileSync('output/1-pixazo.png', Buffer.from(imageBuffer));
    }

    return { success: true, elapsed, imageUrl: data.output };
  } catch (error) {
    return { success: false, elapsed: Date.now() - startTime, error: error.message };
  }
}

async function testReplicate() {
  const startTime = Date.now();
  try {
    const output = await replicate.run("black-forest-labs/flux-schnell", {
      input: {
        prompt: TEST_PROMPT,
        num_outputs: 1,
        aspect_ratio: "1:1",
        output_format: "png"
      }
    });

    const elapsed = Date.now() - startTime;
    const imageUrl = output[0];

    if (imageUrl) {
      const imageResponse = await fetch(imageUrl);
      const imageBuffer = await imageResponse.arrayBuffer();
      fs.writeFileSync('output/2-replicate.png', Buffer.from(imageBuffer));
    }

    return { success: true, elapsed, imageUrl };
  } catch (error) {
    return { success: false, elapsed: Date.now() - startTime, error: error.message };
  }
}

async function testFal() {
  const startTime = Date.now();
  try {
    const result = await fal.subscribe("fal-ai/flux/schnell", {
      input: {
        prompt: TEST_PROMPT,
        image_size: "square_hd",
        num_inference_steps: 4,
        num_images: 1
      }
    });

    const elapsed = Date.now() - startTime;
    const imageUrl = result.data?.images?.[0]?.url;

    if (imageUrl) {
      const imageResponse = await fetch(imageUrl);
      const imageBuffer = await imageResponse.arrayBuffer();
      fs.writeFileSync('output/3-fal.png', Buffer.from(imageBuffer));
    }

    return { success: true, elapsed, imageUrl };
  } catch (error) {
    return { success: false, elapsed: Date.now() - startTime, error: error.message };
  }
}

async function testOpenAI() {
  const startTime = Date.now();
  try {
    const response = await openai.images.generate({
      model: "gpt-image-1",
      prompt: TEST_PROMPT,
      n: 1,
      size: "1024x1024",
      quality: "low"
    });

    const elapsed = Date.now() - startTime;
    const imageData = response.data[0];

    if (imageData.b64_json) {
      const buffer = Buffer.from(imageData.b64_json, 'base64');
      fs.writeFileSync('output/4-openai.png', buffer);
      return { success: true, elapsed, imageUrl: '(base64)' };
    } else if (imageData.url) {
      const imageResponse = await fetch(imageData.url);
      const imageBuffer = await imageResponse.arrayBuffer();
      fs.writeFileSync('output/4-openai.png', Buffer.from(imageBuffer));
      return { success: true, elapsed, imageUrl: imageData.url };
    }

    return { success: true, elapsed };
  } catch (error) {
    return { success: false, elapsed: Date.now() - startTime, error: error.message };
  }
}

// Main test runner
async function runAllTests() {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║       🎨 Image Generation API Test Suite                   ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');
  console.log(`📝 Test Prompt: "${TEST_PROMPT}"`);
  console.log('');

  const results = [];

  // Test 1: Pixazo
  console.log('━'.repeat(60));
  console.log('1️⃣  Testing Pixazo (Flux Schnell) - $0.0012/image');
  console.log('━'.repeat(60));
  const pixazoResult = await testPixazo();
  console.log(pixazoResult.success
    ? `   ✅ SUCCESS - ${pixazoResult.elapsed}ms (${(pixazoResult.elapsed/1000).toFixed(2)}s)`
    : `   ❌ FAILED - ${pixazoResult.error}`);
  results.push({ name: 'Pixazo', price: '$0.0012', ...pixazoResult });

  // Test 2: Replicate
  console.log('');
  console.log('━'.repeat(60));
  console.log('2️⃣  Testing Replicate (Flux Schnell) - $0.003/image');
  console.log('━'.repeat(60));
  const replicateResult = await testReplicate();
  console.log(replicateResult.success
    ? `   ✅ SUCCESS - ${replicateResult.elapsed}ms (${(replicateResult.elapsed/1000).toFixed(2)}s)`
    : `   ❌ FAILED - ${replicateResult.error}`);
  results.push({ name: 'Replicate', price: '$0.003', ...replicateResult });

  // Test 3: fal.ai
  console.log('');
  console.log('━'.repeat(60));
  console.log('3️⃣  Testing fal.ai (Flux Schnell) - $0.003/MP');
  console.log('━'.repeat(60));
  const falResult = await testFal();
  console.log(falResult.success
    ? `   ✅ SUCCESS - ${falResult.elapsed}ms (${(falResult.elapsed/1000).toFixed(2)}s)`
    : `   ❌ FAILED - ${falResult.error}`);
  results.push({ name: 'fal.ai', price: '$0.003', ...falResult });

  // Test 4: OpenAI
  console.log('');
  console.log('━'.repeat(60));
  console.log('4️⃣  Testing OpenAI (gpt-image-1 low) - $0.005/image');
  console.log('━'.repeat(60));
  const openaiResult = await testOpenAI();
  console.log(openaiResult.success
    ? `   ✅ SUCCESS - ${openaiResult.elapsed}ms (${(openaiResult.elapsed/1000).toFixed(2)}s)`
    : `   ❌ FAILED - ${openaiResult.error}`);
  results.push({ name: 'OpenAI', price: '$0.005', ...openaiResult });

  // Summary
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║                    📊 TEST SUMMARY                         ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');
  console.log('┌─────────────┬──────────┬──────────┬────────────────────────┐');
  console.log('│ API         │ Price    │ Status   │ Response Time          │');
  console.log('├─────────────┼──────────┼──────────┼────────────────────────┤');

  for (const r of results) {
    const status = r.success ? '✅ PASS' : '❌ FAIL';
    const time = r.success ? `${(r.elapsed/1000).toFixed(2)}s` : 'N/A';
    console.log(`│ ${r.name.padEnd(11)} │ ${r.price.padEnd(8)} │ ${status.padEnd(8)} │ ${time.padEnd(22)} │`);
  }

  console.log('└─────────────┴──────────┴──────────┴────────────────────────┘');

  const successCount = results.filter(r => r.success).length;
  console.log('');
  console.log(`📈 Overall: ${successCount}/4 APIs working`);

  if (successCount === 4) {
    console.log('🎉 All APIs are ready for fallback system implementation!');
  } else {
    console.log('⚠️  Some APIs failed. Please check the errors above.');
  }

  console.log('');
  console.log('📁 Generated images saved to: ./output/');
  console.log('   - 1-pixazo.png');
  console.log('   - 2-replicate.png');
  console.log('   - 3-fal.png');
  console.log('   - 4-openai.png');
}

runAllTests();
