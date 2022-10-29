const sharp = require('sharp');
const { GetObjectCommand, S3Client } = require('@aws-sdk/client-s3');

async function handler(event, context) {
    let imageKey = event.rawPath.replace('/','');
    let image = await getImage(process.env.BUCKET,imageKey);
    let body  = await resizeImage(image.body, {
        width: parseInt(event.queryStringParameters.w),
        height: parseInt(event.queryStringParameters.h),
    });

    return {
        statusCode: 200,
        headers: { "Content-Type": image.contentType },
        body: body.toString('base64'),
        isBase64Encoded: true
    }
}

async function getImage(bucket,imageKey) {
       const s3Client = new S3Client();
       return new Promise(async (resolve,reject)=>{
        try {
            let getCommand = new GetObjectCommand({
                Bucket: bucket,
                Key: imageKey
            });
            let response = await s3Client.send(getCommand);
            let chunks  = [];
            response.Body.on('data',(chunk)=> chunks.push(chunk));
            response.Body.once('end',async ()=>resolve({
                body: Buffer.concat(chunks),
                contentType: response.ContentType
            }));
        } catch (error) {
            reject(error);
        }
    });
}

async function resizeImage(imageBuffer,options) {
    return sharp(imageBuffer).resize(options).toBuffer();
}

exports.handler = handler;