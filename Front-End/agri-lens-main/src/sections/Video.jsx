import React from "react";
import VideoImg from "../assets/video.png";

const Video = () => {
  return (
    <div className="relative w-full h-[80vh] sm:h-screen flex items-center justify-center">
      {/* Background Image */}
      <img
        src={VideoImg}
        alt="Agriculture Matters"
        className="absolute inset-0 w-full h-full object-cover"
      />

      {/* Overlay for Better Readability */}
      <div className="absolute inset-0 bg-black opacity-50"></div>

      {/* Left-Aligned Text */}
      <div className="absolute left-5 sm:left-10 md:left-20 top-1/2 transform -translate-y-1/2 text-white z-10">
        <h1 className="text-base sm:text-xl md:text-4xl font-bold leading-tight max-w-[300px] sm:max-w-[400px] md:max-w-[600px]">
          Agriculture Matters to <br className="hidden sm:block" />
          the Future of Egypt
        </h1>
      </div>

      {/* Centered Play Button */}
      <div className="absolute flex flex-col items-center z-10">
        <button className="bg-white p-3 sm:p-4 md:p-6 rounded-full flex items-center justify-center shadow-lg cursor-pointer transition-transform duration-300 hover:scale-110">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 16 16"
            className="w-5 sm:w-6 md:w-8 h-5 sm:h-6 md:h-8 text-black"
          >
            <path d="M11.596 8.697l-6 3.5A1 1 0 0 1 4 11.5v-7a1 1 0 0 1 1.596-.802l6 3.5a1 1 0 0 1 0 1.697z" />
          </svg>
        </button>
        <span className="mt-2 text-[#F7C35F] font-['Passions_Conflict'] text-lg sm:text-xl md:text-2xl">
          Watch the video
        </span>
      </div>
    </div>
  );
};

export default Video;
