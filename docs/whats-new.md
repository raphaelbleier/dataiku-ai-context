# Dataiku Docs — whats-new

## [whats-new/2026/2026]

# 2026

This page highlights major Developer Guide updates from 2026. For product release notes, see [our documentation](<https://doc.dataiku.com/dss/latest/release_notes/index.html> "\(in Dataiku DSS v14\)"). Only key additions are shown; bug fixes and minor changes are not included.

---

## [whats-new/2026/february]

# February 2026

This page highlights major Developer Guide updates from February 2026. For product release notes, see [our documentation](<https://doc.dataiku.com/dss/latest/release_notes/index.html> "\(in Dataiku DSS v14\)"). Only key additions are shown; bug fixes and minor changes are not included.

## Adding visual dependencies to your Code Agent settings

You can add visual dependencies to your Code Agent to show interactions in the **Flow**.

[Adding visual dependencies to your Code Agent settings](<../../concepts-and-examples/agents.html#ce-agents-visual-dependencies>)

## Manipulating Artifact Fields with Govern Custom Actions

This tutorial teaches you how to use Govern Custom Actions to read and write values from artifact fields, including performing calculations and updating fields dynamically. You’ll learn to configure custom fields, create and link custom actions, and implement Python scripts to automate field manipulation within Govern projects. By the end, you’ll understand how to build interactive, data-driven custom actions for your governance workflows.

[Manipulating Artifact Fields with Govern Custom Actions](<../../tutorials/govern/action-calculation/index.html>)

## Using a code assistant in Code Studios: GitHub Copilot

This tutorial walks you through integrating GitHub Copilot into a Dataiku Code Studio. Readers will learn how to set up a Code Studio, install the Copilot extension, and start using AI-assisted coding within their environment.

[Using a code assistant in Code Studios: GitHub Copilot](<../../tutorials/devtools/code-studio/using-code-assistant-copilot/index.html>)

## Accessing and understanding logs for WebApps

This tutorial guides readers through accessing and understanding logs in Dataiku Web Applications. By following the steps, you’ll learn to create a web app, locate and interpret various log types, and explore log history to troubleshoot and monitor your applications effectively.

[Accessing and understanding logs for WebApps](<../../tutorials/webapps/common/logs/index.html>)

## Aligning an LLM

This tutorial explains advanced techniques for aligning large language models (LLMs) in Dataiku, covering Reinforcement Learning from Human Feedback (RLHF), Reinforcement Learning from AI Feedback (RLAIF), and Reinforcement Learning with Verifiable Rewards (RLVR). Readers will learn to implement each alignment method with practical code examples, leverage Dataiku’s tooling for data collection and orchestration, and understand when to use each approach to achieve optimal model performance.

[Advanced model alignment: RLHF, RLAIF, and RLVR in Dataiku](<../../tutorials/genai/llm/alignment/index.html>)

---

## [whats-new/2026/january]

# January 2026

This page highlights major Developer Guide updates from January 2026. For product release notes, see [our documentation](<https://doc.dataiku.com/dss/latest/release_notes/index.html> "\(in Dataiku DSS v14\)"). Only key additions are shown; bug fixes and minor changes are not included.

## What’s new is live!

In early 2026, we will launch a new Release Notes section in the Developer Guide. It highlights key updates and features added in 2026, excluding minor changes or bug fixes. Updates are listed by month and year.

[What’s new](<../index.html>)

## Adding artifact documentation to Agent/tool

This documentation addition defines how the **Dataiku LLM Mesh** handles supplemental data returned by an AI agent, specifically distinguishing between what the agent knows (**Sources**) and what the agent created for you (**Artifacts**).

[Agent response: sources and artifacts](<../../concepts-and-examples/agents.html#ce-llm-agent-sources-artifacts>)

## Using a code assistant in Code Studios: OpenCode

This tutorial guides users through integrating OpenCode, an AI coding assistant, within Dataiku Code Studio. The guide shows how to connect Dataiku’s LLM Mesh to developer workspaces like VS Code, enabling a context-aware AI assistant that helps write, debug, and explain code.

[Using a code assistant in Code Studios: OpenCode](<../../tutorials/devtools/code-studio/using-code-assistant-opencode/index.html>)

## Using Generative Adversarial Networks to generate synthetic images

This tutorial provides a step-by-step guide to creating a Generative Adversarial Network (GAN) for generating synthetic images. It walks you through the entire workflow, starting with environment setup and data preparation, then building the generator and discriminator models. The tutorial also demonstrates how to train the GAN, track experiments using MLflow, and deploy your trained model for practical use. By the end, you’ll have hands-on experience with all the essential stages of a modern GAN project.

[Using Generative Adversarial Networks to generate synthetic images](<../../tutorials/genai/multimodal/gan/images-generation/index.html>)

## Transfer Learning Techniques

Transfer learning encompasses techniques that enable data scientists and engineers to build high-performing deep learning models without the massive computational and data labeling costs typically required when training from scratch.

This section examines two distinct subdomains of transfer learning, depending on the availability of labeled data and the degree of similarity between the source and target tasks.

### Transductive transfer learning

[This tutorial](<../../tutorials/machine-learning/others/transfer-learning/transductive-learning.html>) focuses on scenarios where labeled target data is available, the source and target tasks are the same, but the domain changes. For example, a sentiment analysis model trained on survey response data may need to be adapted to understand the nuances of product reviews.

### Unsupervised transfer learning

[This tutorial](<../../tutorials/machine-learning/others/transfer-learning/unsupervised-transfer-learning.html>) addresses the challenge of data scarcity. Unsupervised transfer learning techniques are helpful for adapting a model to a new domain when you have a target dataset, but no labels. For example, a model trained to detect anomalies in satellite images may need to be adapted to identify instances of illegal deforestation; however, the target dataset is large enough that hand-labeling the data is a significant challenge.

[Transfer Learning Techniques](<../../tutorials/machine-learning/others/transfer-learning/index.html>)

## Pre-training Large Language Models in Dataiku

This is a practical, step-by-step tutorial for pre-training large language models (LLMs) in Dataiku. By following this guide, users will learn how to import nanoGPT code, prepare a Shakespeare dataset, train a transformer-based model, and generate and evaluate text outputs within Dataiku. The tutorial explains the technical setup, workflow adaptations, and evaluation metrics, so users can experiment with LLM pre-training on a smaller scale and consider next steps such as fine-tuning or working with larger datasets for specialized cases.

[Pre-training Large Language Models in Dataiku](<../../tutorials/genai/llm/pre-training/index.html>)

---

## [whats-new/index]

# What’s new  
  
This page highlights major Developer Guide updates from January 2026. For product release notes, see [our documentation](<https://doc.dataiku.com/dss/latest/release_notes/index.html> "\(in Dataiku DSS v14\)"). Only key additions are shown; bug fixes and minor changes are not included.

## 2026

[January 2026](<2026/january.html>)  
[February 2026](<2026/february.html>)