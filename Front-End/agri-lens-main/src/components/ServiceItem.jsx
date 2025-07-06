import React from "react";

const ServiceItem = ({ icon, title, text }) => {
  return (
    <div className="flex flex-col sm:flex-row items-start sm:items-center space-y-4 sm:space-y-0 sm:space-x-4">
      <div className="flex items-center justify-center">
        <img
          src={icon}
          alt={title}
          className="w-[60px] h-[60px] sm:w-[70px] sm:h-[70px] md:w-[80px] md:h-[80px] lg:w-[90px] lg:h-[90px] object-contain"
        />
      </div>
      <div className="text-center sm:text-left">
        <h4 className="text-lg sm:text-xl md:text-2xl font-semibold font-[livvic]">
          {title}
        </h4>
        <p className="text-gray-200 text-sm sm:text-base md:text-lg font-[century_gothic]">
          {text}
        </p>
      </div>
    </div>
  );
};

export default ServiceItem;
