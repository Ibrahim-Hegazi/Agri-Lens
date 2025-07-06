import React from "react";
import ServicesImg from "../assets/services.png";
import Icon1 from "../assets/icon (1).png";
import Icon2 from "../assets/icon (2).png";
import ServiceItem from "../components/ServiceItem";

const Services = () => {
  return (
    <div className="relative flex flex-col lg:flex-row items-center bg-[#5C7745] text-white p-6 sm:p-10 lg:p-20">
      {/* Left Image Section */}
      <div className="relative w-full lg:w-1/2 h-[300px] sm:h-[400px] lg:h-[500px]">
        <div
          className="absolute inset-0 w-full h-full bg-cover bg-center rounded-lg"
          style={{ backgroundImage: `url(${ServicesImg})` }}
        ></div>
      </div>

      {/* Right Content Section */}
      <div className="w-full lg:w-1/2 lg:pl-10 mt-10 lg:mt-0">
        <h3 className="text-xs sm:text-sm uppercase tracking-wide font-semibold font-[century_gothic]">
          Modern Agriculture
        </h3>
        <h2 className="text-2xl sm:text-3xl lg:text-4xl font-bold my-4 font-[livvic]">
          Providing High Quality
        </h2>

        {/* Services */}
        <div className="mt-6 space-y-6">
          <ServiceItem
            icon={Icon1}
            title="Our Agriculture Growth"
            text="Enhancing crop yields with smart farming and AI-driven precision techniques."
          />
          {/* Thin horizontal line */}
          <hr className="border-t border-gray-300 w-full opacity-50" />
          <ServiceItem
            icon={Icon2}
            title="Making Healthy Foods"
            text="Ensuring sustainable, high-quality food production through optimized farming."
          />
        </div>
      </div>
    </div>
  );
};

export default Services;
