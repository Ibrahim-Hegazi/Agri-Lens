# 🌱 Agri Lens – Smart Farming System

**Mansoura University – Faculty of Computers and Information**  
**Graduation Project – Computer Science Department**

Agri Lens is a smart farming system that leverages embedded systems and AI to improve crop monitoring, automate irrigation, and detect plant diseases—focusing particularly on strawberry plants. This project reflects our commitment to supporting sustainable agriculture using modern technology.

---

## 📚 Table of Contents
- [👥 Contributors](#-contributors)
- [📖 Project Overview](#-project-overview)
- [🎯 Project Goals](#-project-goals)
- [🛠️ System Architecture](#️-system-architecture)
- [⚙️ How It Works](#️-how-it-works)
- [🧠 AI Based Disease Detection](#️-ai-based-disease-detection)
- [🧰 Technologies Used](#-technologies-used)
- [🌟 Key Features](#-key-features)
- [🧠 Challenges & Solutions](#-challenges--solutions)
- [🙌 Acknowledgments](#-acknowledgments)
- [🔮 Future Work](#-future-work)
- [🖼️ Gallery](#️-gallery)

---

## 👥 Contributors

This project was developed by the **Agri Lens Team**, composed of 10 dedicated students from the Computer Science Department at Mansoura University.

### Team Members
(Add GitHub or LinkedIn profiles if desired)
- Contributor 1  
- Contributor 2  
- Contributor 3  
- Contributor 4  
- Contributor 5  
- Contributor 6  
- Contributor 7  
- Contributor 8  
- Contributor 9  
- Contributor 10  

### Special Thanks
- **[External Hardware Consultant]** – Supported the design and implementation of the mechanical and sensor integration.  
- **[External Backend Consultant]** – Assisted in backend architecture and Firebase integration.

---

## 📖 Project Overview

Agri Lens is a smart farming prototype designed to assist farmers in managing crops more efficiently using automation and computer vision. By automating irrigation and leveraging AI for plant disease detection—especially for strawberry plants—Agri Lens helps reduce manual effort, conserve water, and prevent disease outbreaks at early stages.

---

## 🎯 Project Goals

- Enable early detection of plant diseases through AI-based image analysis  
- Automate irrigation based on real-time soil and weather conditions  
- Build a cost-effective, modular solution accessible to small and medium-scale farmers  
- Improve crop yield and resource efficiency using embedded systems and smart control logic

---

## 🛠️ System Architecture

The system consists of two main circuits and a structured control box built from wood with three planting cells:

### 📷 Circuit 1 – Image Capture Module
- ESP32-CAM for capturing images  
- Stepper Motor mounted on a metal rod for horizontal camera movement  
- Motor Driver (e.g., ULN2003) to control motor  
- Sends plant images to the backend for AI analysis  

### 💧 Circuit 2 – Irrigation & Environmental Monitoring Module
- ESP32 Microcontroller  
- 3 × Soil Moisture Sensors (one per cell)  
- 3 × Water Pumps (one per cell)  
- DHT11 Sensor (placed outside the box)  
- Motor Driver for pump control  
- Automates irrigation based on soil data and environmental readings  

---

## ⚙️ How It Works

### Sensor Data Collection
- Soil moisture sensors monitor water levels in each cell  
- DHT11 measures temperature and humidity  

### Automated Irrigation
- Water pumps activate individually based on real-time moisture levels  
- Controlled through ESP32 logic with thresholds  

### Plant Image Capture
- The ESP32-CAM is mounted on a motorized rail  
- Moves across all cells to capture top-view images of each plant  

### AI-Based Disease Detection
- Captured images are sent to an AI model  
- Focused on detecting strawberry leaf diseases  
- Prediction results are stored in the backend  

### Control Dashboard (Future Integration)
- Users can monitor readings and receive alerts via a mobile/web interface  

---

## 🧠 AI Based Disease Detection

To enable early and precise detection of strawberry plant diseases, we developed a custom AI pipeline using **YOLOv11** with **instance segmentation**. This model provides pixel-level disease localization, enabling timely and targeted interventions.

---

### 🔍 Why YOLOv11?

- **High Accuracy** in identifying diseased regions  
- **Instance Segmentation** for detailed mask-level predictions  
- **Early Detection** of symptoms at initial growth stages  

**Performance on our custom dataset:**

- 🎯 **Box mAP@50**: 76.6%  
- 🎯 **Mask mAP@50**: 76.8%  
- ✅ *Outperforms YOLOv8 in all evaluated metrics*

---

### 🧪 AI Pipeline Overview

#### 📌 1. Requirement Analysis & Data Preparation

- **Diseases Targeted**: *Powdery Mildew*, *Gray Mold*, *Anthracnose*, etc.  
- **Data**: Healthy and diseased leaf images collected from open datasets and web scraping (via FastAI)  
- **Annotation**: Pixel-wise masks labeled in YOLO format using **Roboflow**  
- **Augmentation**: Flipping, rotation, shifting, and scaling to diversify samples  

---

#### 📌 2. Model Selection

- **Architectures Compared**:
  - **YOLOv8-seg**: 151 layers, 3.4M parameters  
  - **YOLOv11-seg**: 253 layers, 22M parameters  

✅ **Final Choice**: YOLOv11-seg, offering better detection and segmentation quality.

---

#### 📌 3. Training & Hyperparameter Tuning

- **Optimizer**: SGD with momentum (0.937)  
- **Learning Rate**: 0.01  
- **Dropout**: 0.0  
- **Patience**: 100 epochs  

Trained to detect and segment individual leaves with high precision.

---

#### 📌 4. Evaluation Summary

| Metric         | YOLOv8 | YOLOv11 |
|----------------|--------|---------|
| Box Precision  | 0.902  | 0.953   |
| Box mAP@50     | 0.703  | 0.766   |
| Mask mAP@50    | 0.703  | 0.768   |
| Mask mAP@50-95 | 0.569  | 0.657   |

✅ **Conclusion**: YOLOv11 achieved consistently better results across all detection and segmentation metrics.

---

#### 📌 5. Deployment

- **Backend**: Deployed via **FastAPI**  
- **Flow**:  
  ESP32-CAM → FastAPI API → YOLOv11 Model → Predictions stored in Firebase  
- **Upcoming**: Flutter-based dashboard for real-time health monitoring and alerts

---




## 🧰 Technologies Used

- **Embedded Systems:** ESP32-CAM, ESP32 Microcontroller  
- **Sensors:** DHT11, Soil Moisture Sensors  
- **Actuators:** Stepper Motor, Mini Water Pumps  
- **AI:** Image Classification Model for Disease Detection  
- **Cloud Services:** Firebase Realtime Database, Supabase (for image storage)  
- **Programming Languages:** C++ (Arduino), Python (AI model), JavaScript (frontend)  
- **Mobile/Web App:** Flutter (planned), React (dashboard design prototype)  

---

## 🌟 Key Features

- Modular farming box with 3 isolated plant environments  
- Automated irrigation using soil condition feedback  
- Mobile ESP32-CAM for image-based plant health monitoring  
- AI-based early disease detection, optimized for strawberries  
- Scalable design for larger farm environments  

---

## 🧠 Challenges & Solutions

| **Challenge**                              | **Solution**                                              |
|-------------------------------------------|-----------------------------------------------------------|
| Integrating multiple ESP32 modules        | Unified communication through Firebase                   |
| Synchronizing motor and camera movement   | Used delay and step-count logic for accurate positioning |
| Disease image dataset limitations         | Focused on strawberry dataset and augmented data         |
| Real-time updates to the mobile app       | Firebase used for seamless data syncing                  |

---

## 🙌 Acknowledgments

We are deeply thankful for the guidance and support provided by our supervisors, faculty members, and external collaborators. Special appreciation to:

- **Faculty of Computers and Information – Mansoura University**  
- **Our hardware consultant** for support in mechanical system design  
- **Our backend consultant** for Firebase and cloud integration  
- **All team members** for their dedication and collaboration throughout this journey  

---

## 🔮 Future Work

- Expand AI model to detect multiple plant diseases  
- Introduce hydroponic irrigation system  
- Develop a complete Flutter-based control app  
- Integrate reinforcement learning for dynamic irrigation control  
- Improve sensor calibration and error handling mechanisms  

---

## 🖼️ Gallery

> 📸 Coming Soon: Final system images, AI prediction samples, mobile app screenshots, and hardware build process.

---
