/**
 * fal.ai Flux Schnell API Test
 * Model: fal-ai/flux/schnell
 * Price: $0.003/megapixel
 */

import 'dotenv/config';
import { fal } from '@fal-ai/client';
import fs from 'fs';

// Configure fal client
fal.config({
  credentials: process.env.FAL_KEY
});

const TEST_PROMPT = "A cute cartoon dog sticker with a happy expression, wearing a red collar, simple flat design, white background";

async function testFal() {
  console.log('='.repeat(50));
  console.log('🎨 Testing fal.ai Flux Schnell API');
  console.log('='.repeat(50));
  console.log(`Prompt: "${TEST_PROMPT}"`);
  console.log('');

  const startTime = Date.now();

  try {
    const result = await fal.subscribe("fal-ai/flux/schnell", {
      input: {
        prompt: TEST_PROMPT,
        image_size: "square_hd", // 1024x1024
        num_inference_steps: 4,
        num_images: 1,
        enable_safety_checker: false
      },
      logs: true,
      onQueueUpdate: (update) => {
        if (update.status === "IN_PROGRESS") {
          console.log(`⏳ Queue status: ${update.status}`);
        }
      }
    });

    const elapsed = Date.now() - startTime;

    console.log('✅ SUCCESS');
    console.log(`⏱️  Response Time: ${elapsed}ms (${(elapsed/1000).toFixed(2)}s)`);
    console.log(`📦 Response:`, JSON.stringify(result.data, null, 2));

    // Download and save image if URL is returned
    if (result.data && result.data.images && result.data.images[0]) {
      const imageUrl = result.data.images[0].url;
      console.log(`🖼️  Image URL: ${imageUrl}`);

      // Download image
      const imageResponse = await fetch(imageUrl);
      const imageBuffer = await imageResponse.arrayBuffer();

      if (!fs.existsSync('output')) {
        fs.mkdirSync('output');
      }

      fs.writeFileSync('output/fal-test.png', Buffer.from(imageBuffer));
      console.log('💾 Image saved to: output/fal-test.png');
    }

    return { success: true, elapsed, data: result.data };

  } catch (error) {
    const elapsed = Date.now() - startTime;
    console.log('❌ FAILED');
    console.log(`⏱️  Time before error: ${elapsed}ms`);
    console.log(`🔴 Error: ${error.message}`);
    if (error.body) {
      console.log(`🔴 Details:`, error.body);
    }
    return { success: false, elapsed, error: error.message };
  }
}

// Run test
testFal().then(result => {
  console.log('');
  console.log('='.repeat(50));
  console.log('Test Result:', result.success ? '✅ PASS' : '❌ FAIL');
  console.log('='.repeat(50));
});
