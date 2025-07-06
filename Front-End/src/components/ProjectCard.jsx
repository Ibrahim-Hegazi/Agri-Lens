import React from "react";
import { ArrowRight } from "lucide-react"; // Import arrow icon

const ProjectCard = ({ image, title, category, isActive }) => {
  return (
    <div
      className={`relative rounded-xl overflow-hidden cursor-pointer transition-all duration-300 
        ${
          isActive
            ? "border-2 border-[#F7C35F]"
            : "opacity-60 hover:opacity-100"
        }
        w-[80%] sm:w-[250px] md:w-[280px] lg:w-[240px] xl:w-[260px]`}
    >
      {/* Project Image */}
      <img
        src={image}
        alt={title}
        className="w-full h-[250px] md:h-[300px] object-cover"
      />

      {/* Overlay */}
      <div className="absolute inset-0 bg-black opacity-20"></div>

      {/* Project Details */}
      {isActive && (
        <div className="absolute bottom-5 left-5 right-5 text-white flex items-center justify-between">
          <div>
            <p className="text-xs sm:text-sm text-[#F7C35F] uppercase">
              {category}
            </p>
            <h3 className="text-sm sm:text-lg font-semibold">{title}</h3>
          </div>
          <ArrowRight className="w-5 h-5 text-[#F7C35F] transition-transform duration-300" />
        </div>
      )}
    </div>
  );
};

export default ProjectCard;
