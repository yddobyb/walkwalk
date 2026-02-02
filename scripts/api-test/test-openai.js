/**
 * OpenAI gpt-image-1 API Test
 * Model: gpt-image-1 (low quality)
 * Price: $0.005/image (1024x1024, low quality)
 */

import 'dotenv/config';
import OpenAI from 'openai';
import fs from 'fs';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  timeout: 120000, // 2 minute timeout
});

const TEST_PROMPT = "A cute cartoon dog sticker with a happy expression, wearing a red collar, simple flat design, white background";

async function testOpenAI() {
  console.log('='.repeat(50));
  console.log('🎨 Testing OpenAI gpt-image-1 API');
  console.log('='.repeat(50));
  console.log(`Prompt: "${TEST_PROMPT}"`);
  console.log('');
  console.log('⏳ Generating image... (this may take 30-60 seconds)');

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

    console.log('');
    console.log('✅ SUCCESS');
    console.log(`⏱️  Response Time: ${elapsed}ms (${(elapsed/1000).toFixed(2)}s)`);

    // Save image if base64 data or URL is returned
    if (response.data && response.data[0]) {
      const imageData = response.data[0];

      if (!fs.existsSync('output')) {
        fs.mkdirSync('output');
      }

      if (imageData.b64_json) {
        // Base64 response
        const buffer = Buffer.from(imageData.b64_json, 'base64');
        fs.writeFileSync('output/openai-test.png', buffer);
        console.log('💾 Image saved to: output/openai-test.png (from base64)');
      } else if (imageData.url) {
        // URL response
        console.log(`🖼️  Image URL: ${imageData.url}`);
        const imageResponse = await fetch(imageData.url);
        const imageBuffer = await imageResponse.arrayBuffer();
        fs.writeFileSync('output/openai-test.png', Buffer.from(imageBuffer));
        console.log('💾 Image saved to: output/openai-test.png');
      }
    }

    return { success: true, elapsed, data: response };

  } catch (error) {
    const elapsed = Date.now() - startTime;
    console.log('');
    console.log('❌ FAILED');
    console.log(`⏱️  Time before error: ${elapsed}ms`);
    console.log(`🔴 Error: ${error.message}`);
    if (error.code) {
      console.log(`🔴 Code: ${error.code}`);
    }
    if (error.status) {
      console.log(`🔴 Status: ${error.status}`);
    }
    return { success: false, elapsed, error: error.message };
  }
}

// Run test with proper exit
testOpenAI()
  .then(result => {
    console.log('');
    console.log('='.repeat(50));
    console.log('Test Result:', result.success ? '✅ PASS' : '❌ FAIL');
    console.log('='.repeat(50));
    process.exit(result.success ? 0 : 1);
  })
  .catch(err => {
    console.error('Unexpected error:', err);
    process.exit(1);
  });
