import React from "react";

const TestimonialCard = ({ name, role, text, image }) => {
  return (
    <div className="bg-[#1D3B26] text-white py-8 px-4 sm:py-12 sm:px-6 md:py-16 md:px-8 flex flex-col items-center">
      <div className="mt-6 sm:mt-8 md:mt-10 flex flex-col md:flex-row items-center max-w-4xl mx-auto">
        <div className="relative flex-shrink-0 mb-6 md:mb-0">
          <img
            src={image}
            alt={name}
            className="w-[150px] h-[150px] sm:w-[200px] sm:h-[200px] md:w-[250px] md:h-[250px] lg:w-[300px] lg:h-[300px] xl:w-[350px] xl:h-[350px] rounded-full border-4 border-gray-700 object-cover"
          />
        </div>
        <div className="md:ml-8 text-gray-300 text-center md:text-left">
          <p className="text-sm sm:text-base md:text-lg italic">“{text}”</p>
          <p className="mt-4 text-white font-bold text-base sm:text-lg md:text-xl">
            {name}
          </p>
          <p className="text-gray-500 text-xs sm:text-sm md:text-base">
            {role}
          </p>
        </div>
      </div>
    </div>
  );
};

export default TestimonialCard;
