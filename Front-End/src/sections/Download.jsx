import React from "react";
import Icon1 from "../assets/icon (1).png"; // Ensure correct path

const Download = () => {
  return (
    <div
      className="relative w-full h-auto min-h-64 px-5 sm:px-10 flex flex-wrap justify-between items-center"
      style={{
        background:
          "linear-gradient(to right, #EAC06B, rgba(234, 192, 107, 0))",
        backgroundColor: "#1d2b1f", // Background under transparent gradient
      }}
    >
      {/* Left Side: Icon & Text */}
      <div className="flex items-center space-x-4 w-full md:w-auto mb-4 md:mb-0">
        <div className="bg-[#2E4F32] rounded-full w-16 h-16 flex justify-center items-center">
          <img src={Icon1} alt="Agriculture Icon" className="w-10 h-10" />
        </div>
        <p className="text-[#2E4F32] text-3xl sm:text-6xl font-[passions_conflict] text-center">
          We are Leaders in Agriculture
        </p>
      </div>

      {/* Right Side: Button with extra space */}
      <button className="bg-[#F4B860] text-black px-6 py-3 md:px-8 md:py-4 shadow-md rounded-xl hover:bg-black hover:text-[#F4B860] cursor-pointer mr-5 md:mr-10">
        DOWNLOAD APP
      </button>
    </div>
  );
};

export default Download;
