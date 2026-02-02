/**
 * Pixazo Flux Schnell API Test
 * Model: Flux Schnell (Free Beta)
 * Price: $0.0012/image (free during beta)
 */

import 'dotenv/config';
import fs from 'fs';

const API_KEY = process.env.PIXAZO_API_KEY;
const API_URL = 'https://gateway.pixazo.ai/flux-1-schnell/v1/getData';

const TEST_PROMPT = "A cute cartoon dog sticker with a happy expression, wearing a red collar, simple flat design, white background";

async function testPixazo() {
  console.log('='.repeat(50));
  console.log('🎨 Testing Pixazo Flux Schnell API');
  console.log('='.repeat(50));
  console.log(`Prompt: "${TEST_PROMPT}"`);
  console.log('');

  const startTime = Date.now();

  try {
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': API_KEY
      },
      body: JSON.stringify({
        prompt: TEST_PROMPT,
        num_steps: 4,
        height: 1024,
        width: 1024
      })
    });

    const elapsed = Date.now() - startTime;

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`HTTP ${response.status}: ${errorText}`);
    }

    const data = await response.json();

    console.log('✅ SUCCESS');
    console.log(`⏱️  Response Time: ${elapsed}ms (${(elapsed/1000).toFixed(2)}s)`);
    console.log(`📦 Response:`, JSON.stringify(data, null, 2));

    // Download and save image if URL is returned
    if (data.output) {
      console.log(`🖼️  Image URL: ${data.output}`);

      // Download image
      const imageResponse = await fetch(data.output);
      const imageBuffer = await imageResponse.arrayBuffer();

      if (!fs.existsSync('output')) {
        fs.mkdirSync('output');
      }

      fs.writeFileSync('output/pixazo-test.png', Buffer.from(imageBuffer));
      console.log('💾 Image saved to: output/pixazo-test.png');
    }

    return { success: true, elapsed, data };

  } catch (error) {
    const elapsed = Date.now() - startTime;
    console.log('❌ FAILED');
    console.log(`⏱️  Time before error: ${elapsed}ms`);
    console.log(`🔴 Error: ${error.message}`);
    return { success: false, elapsed, error: error.message };
  }
}

// Run test
testPixazo().then(result => {
  console.log('');
  console.log('='.repeat(50));
  console.log('Test Result:', result.success ? '✅ PASS' : '❌ FAIL');
  console.log('='.repeat(50));
});
