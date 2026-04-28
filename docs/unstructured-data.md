# Dataiku Docs — unstructured-data

## [unstructured-data/audio/index]

# Audio

Audio files can be manipulated with the help of the following plugin:

  * [Plugin: Speech to text](<https://www.dataiku.com/dss/plugins/info/speech-to-text.html>): Use this plugin to transcript audio files containing speech.




Note

This plugin is _not_ fully supported by Dataiku.

---

## [unstructured-data/image/index]

# Images

Some common tasks when working with images include: feature extraction, classification, image segmentation, object recognition…

Dataiku natively integrates the following capabilities:

  * [Computer vision in Visual ML](<../../machine-learning/computer-vision/index.html>): Perform [image classification](<https://knowledge.dataiku.com/latest/ml/complex-data/images/classification-visual/tutorial-index.html>) and object detection in a visual way, no code needed.

  * [Deep learning in Visual ML](<../../machine-learning/deep-learning/index.html>): Build deep learning models in Keras in a semi-visual way.




In addition, you can leverage any image processing library with Python or R code in Dataiku or use external services.

## External services

---

## [unstructured-data/image/object-detection-cpu]

# Object detection in images

This plugin provides recipes to detect the location and class of several objects in images using Deep Learning. Object detection consists in detecting the location and class of several objects in the same image.

Note

This capability is provided by the “Object Detection” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

This plugin is [Not supported](<../../troubleshooting/support-tiers.html>)

Warning

Starting with Dataiku version 10 this plugin is partially superseded by the [native object detection capabilities](<../../machine-learning/computer-vision/index.html>).

This plugin comes with four recipes and a macro.

## Fine-tune detection model

This recipe does transfer learning and finetuning to adapt a pretrained model on a new dataset.

## Detect objects

This recipe detects objects in images and produces a dataset storing all the detected objects with their class and localization.

## Display bounding boxes

This recipe gives objects localization, draw on images a bounding box around the objects.

## Detect objects in video

This recipe detects objects in a video and produces a copy of the video with the objects drawn on it. If ffmpeg is installed the video will be of the mp4 format, else of the mkv format. To install ffmpeg, you can use the following command:

  * On Ubuntu: `sudo apt-get install ffmpeg`

  * On macOS: `brew install ffmpeg`

---

## [unstructured-data/video/index]

# Video

Video files can be manipulated with the help of the following plugin:

  * [Object detection in images plugin](<../image/object-detection-cpu.html>): This plugin uses a deep learning model to detect the location and class of objects in video frames.

  * [Video processing plugin](<video-processing.html>): This plugin enables AI agents to analyze video content using multimodal Large Language Models (LLMs).




## External services

---

## [unstructured-data/video/video-processing]

# Video processing

Note

This capability is provided by the “video-processing” plugin, which you need to install. Please see [Installing plugins](<../../plugins/installing.html>).

This plugin is [Not supported](<../../troubleshooting/support-tiers.html>)

## Features

  * **Watch Video Tool** : An agent tool that extracts frames from videos and analyzes them using vision-capable LLMs.

  * **Intelligent frame sampling** : Up to 10 evenly-spaced frames.

  * **Automatic image optimization** : Efficient LLM processing.

  * **Seamless integration** : Works within the Dataiku agent framework.




## Configuration

### Watch Video Tool

Configure the tool with the following parameters:

Parameter | Type | Description  
---|---|---  
`input_folder` | Folder | Dataiku managed folder containing your video files  
`llm_id` | LLM | A multimodal LLM connection (must support vision)  
  
## Usage

The Watch Video tool is designed to be used by Dataiku agents. When invoked, it accepts:

  * `video_name`: The filename of the video to analyze (e.g., `my_video.mp4`)

  * `question`: A specific question about the video content




## Example

**Input:**
    
    
    {
      "video_name": "product_demo.mp4",
      "question": "What are the main features shown in this demo?"
    }
    

**Output:**
    
    
    {
      "output": "Visual Analysis of 'product_demo.mp4': The demo shows...",
      "sources": []
    }
    

## How It Works

  1. **Video Validation** : Checks that the requested video exists in the configured folder.

  2. **Frame Extraction** : Downloads the video and extracts up to 10 evenly-spaced frames using OpenCV.

  3. **Image Optimization** : Resizes frames to 512px width to reduce token consumption.

  4. **LLM Analysis** : Sends frames with the user’s question to a multimodal LLM.

  5. **Response** : Returns the LLM’s visual analysis.