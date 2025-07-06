import React from "react";
import { CheckCircle } from "lucide-react";
import Plant from "../assets/about.png";
import Icon from "../assets/icon.png";

const About = () => {
  return (
    <section className="bg-[#2F402A] text-white py-16 px-6 sm:px-10 flex justify-center">
      <div className="max-w-6xl w-full flex flex-col md:flex-row items-center gap-10">
        {/* Image Section */}
        <div className="relative w-full md:w-1/2 flex justify-center">
          <div className="absolute -left-6 -bottom-0 bg-[#F7C35F] w-56 sm:w-72 h-56 sm:h-72 rounded-lg hidden md:block"></div>
          <div className="relative overflow-hidden rounded-lg shadow-lg w-full max-w-md md:max-w-none">
            <img
              src={Plant}
              alt="Greenhouse plants"
              className="w-full h-auto bg-[#2F402A] object-cover rounded-lg"
            />
            {/* Project Info Box */}
            <div className="absolute bottom-0 left-0 w-full bg-[#6D8C54] p-3 sm:p-4 rounded-b-lg text-white flex items-center gap-2 sm:gap-3">
              <img src={Icon} alt="Icon" className="h-12 sm:h-16" />
              <div className="border-l border-white pl-2 sm:pl-3">
                <span className="text-xl sm:text-2xl font-bold">86,700</span>
                <p className="text-xs sm:text-sm">
                  Successfully Completed Projects
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Text Section */}
        <div className="w-full md:w-1/2 flex flex-col items-start text-left">
          <h4 className="text-xs sm:text-sm uppercase text-gray-400">
            Our Introduction
          </h4>
          <h2 className="text-3xl sm:text-4xl font-bold mt-2">
            Digital Agriculture
          </h2>
          <h3 className="text-lg sm:text-xl text-[#F7C35F] font-semibold mt-2">
            We’re Leaders in Agriculture
          </h3>
          <p className="text-gray-300 mt-2 text-sm sm:text-base">
            With cutting-edge technology and AI-driven solutions, we help
            farmers optimize their yields, reduce resource waste, and improve
            efficiency. Our smart farming solutions integrate real-time
            monitoring, automated irrigation, and AI-powered disease detection
            to revolutionize agriculture.
          </p>
          <ul className="mt-4 space-y-2 sm:space-y-3 text-sm sm:text-base">
            <li className="flex items-center gap-2">
              <CheckCircle className="text-[#F7C35F]" size={18} sm:size={20} />
              Precision farming for better crop management
            </li>
            <li className="flex items-center gap-2">
              <CheckCircle className="text-[#F7C35F]" size={18} sm:size={20} />
              AI-powered disease detection and prevention
            </li>
            <li className="flex items-center gap-2">
              <CheckCircle className="text-[#F7C35F]" size={18} sm:size={20} />
              Sustainable and efficient resource utilization
            </li>
          </ul>
        </div>
      </div>
    </section>
  );
};

export default About;
