/**
 * Replicate Flux Schnell API Test
 * Model: black-forest-labs/flux-schnell
 * Price: $0.003/image
 */

import 'dotenv/config';
import Replicate from 'replicate';
import fs from 'fs';

const replicate = new Replicate({
  auth: process.env.REPLICATE_API_TOKEN,
});

const TEST_PROMPT = "A cute cartoon dog sticker with a happy expression, wearing a red collar, simple flat design, white background";

async function testReplicate() {
  console.log('='.repeat(50));
  console.log('🎨 Testing Replicate Flux Schnell API');
  console.log('='.repeat(50));
  console.log(`Prompt: "${TEST_PROMPT}"`);
  console.log('');

  const startTime = Date.now();

  try {
    const output = await replicate.run(
      "black-forest-labs/flux-schnell",
      {
        input: {
          prompt: TEST_PROMPT,
          num_outputs: 1,
          aspect_ratio: "1:1",
          output_format: "png",
          output_quality: 90
        }
      }
    );

    const elapsed = Date.now() - startTime;

    console.log('✅ SUCCESS');
    console.log(`⏱️  Response Time: ${elapsed}ms (${(elapsed/1000).toFixed(2)}s)`);
    console.log(`📦 Response:`, output);

    // Download and save image if URL is returned
    if (output && output[0]) {
      const imageUrl = output[0];
      console.log(`🖼️  Image URL: ${imageUrl}`);

      // Download image
      const imageResponse = await fetch(imageUrl);
      const imageBuffer = await imageResponse.arrayBuffer();

      if (!fs.existsSync('output')) {
        fs.mkdirSync('output');
      }

      fs.writeFileSync('output/replicate-test.png', Buffer.from(imageBuffer));
      console.log('💾 Image saved to: output/replicate-test.png');
    }

    return { success: true, elapsed, data: output };

  } catch (error) {
    const elapsed = Date.now() - startTime;
    console.log('❌ FAILED');
    console.log(`⏱️  Time before error: ${elapsed}ms`);
    console.log(`🔴 Error: ${error.message}`);
    return { success: false, elapsed, error: error.message };
  }
}

// Run test
testReplicate().then(result => {
  console.log('');
  console.log('='.repeat(50));
  console.log('Test Result:', result.success ? '✅ PASS' : '❌ FAIL');
  console.log('='.repeat(50));
});
