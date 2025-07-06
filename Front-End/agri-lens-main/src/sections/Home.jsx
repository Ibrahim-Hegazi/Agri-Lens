import React from "react";
import HeroImg from "../assets/hero.png";
import Leaves from "../assets/leaves.png";

const Home = () => {
  return (
    <div
      className="relative bg-cover bg-center h-screen flex items-center px-6 sm:px-10 md:px-20"
      style={{ backgroundImage: `url(${HeroImg})`, backgroundSize: "cover" }}
    >
      {/* Dark Overlay */}
      <div className="absolute inset-0 bg-black opacity-50"></div>

      {/* Content Container */}
      <div className="relative z-10 text-white w-full max-w-5xl mx-auto flex flex-col md:flex-row items-center md:items-start">
        {/* Left Text Content */}
        <div className="w-full md:w-1/2 text-center md:text-left">
          <h1 className="text-white text-xl sm:text-2xl font-bold mb-2 sm:mb-4 font-['Century_Gothic']">
            Original & Natural
          </h1>

          <div className="flex justify-center md:justify-start items-center space-x-2">
            <h1 className="text-[#F7C35F] text-4xl sm:text-5xl md:text-6xl font-['Livvic'] font-bold">
              Agri Lens
            </h1>
            <img src={Leaves} alt="Leaves" className="h-8 sm:h-10" />
          </div>

          <p className="text-base sm:text-lg mb-4 sm:mb-6">
            <span className="text-3xl sm:text-5xl font-['Livvic'] font-bold">
              Good production
            </span>
            <br />
            <span className="font-['Century_Gothic']">
            At Agri Lens, we blend technology with nature to optimize crop yields, reduce waste, and enhance sustainability.
            <br /> Our innovative smart farming solutions help farmers monitor plant health, automate irrigation, and detect diseases early—empowering a greener tomorrow.
            </span>
          </p>

          {/* Call to Action Button */}
          {/* <button className="bg-[#F7C35F] text-black cursor-pointer text-center py-3 sm:py-4 px-8 sm:px-10 rounded-2xl hover:bg-black hover:text-[#F7C35F] transition duration-300 text-lg sm:text-2xl font-semibold font-['Livvic']">
            Discover More
          </button> */}
        </div>
      </div>
    </div>
  );
};

export default Home;
