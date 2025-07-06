import React, { useState } from "react";
import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";
import ProjectCard from "../components/ProjectCard";
import project1 from "../assets/project1.png";
import project2 from "../assets/project2.png";
import project3 from "../assets/project3.png";
import project4 from "../assets/project4.png";

const projects = [
  { image: project1, title: "Greenhouse Farming", category: "Agriculture" },
  {
    image: project2,
    title: "Digital Way Of Agriculture",
    category: "Agriculture",
  },
  { image: project3, title: "Hydroponic Cultivation", category: "Agriculture" },
  { image: project4, title: "AI in Farming", category: "Research" },
];

const Projects = () => {
  const [currentSlide, setCurrentSlide] = useState(0);

  const settings = {
    dots: true,
    infinite: true,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
    arrows: false,
    beforeChange: (oldIndex, newIndex) => setCurrentSlide(newIndex),
    customPaging: (i) => (
      <div
        className={`w-3 h-3 rounded-full transition-all duration-300 ${
          i === currentSlide % 3 ? "bg-[#F7C35F] w-5" : "bg-gray-400"
        }`}
      ></div>
    ),
    dotsClass: "slick-dots custom-dots",
    responsive: [
      { breakpoint: 1280, settings: { slidesToShow: 3 } },
      { breakpoint: 1024, settings: { slidesToShow: 2 } },
      { breakpoint: 768, settings: { slidesToShow: 1 } },
    ],
  };

  return (
    <div className="bg-[#1D3B26] py-16 px-4">
      {/* Section Heading */}
      <div className="text-center text-white mb-10">
        <p className="text-xs sm:text-sm uppercase font-[century_gothic] tracking-wide">
          Recently Completed Work
        </p>
        <h2
          className="font-livvic font-bold text-[50px] leading-[62.75px] tracking-0 mt-2"
          style={{ fontFamily: "Livvic", fontWeight: 700 }}
        >
          Explore Our Projects
        </h2>
      </div>

      {/* Project Carousel */}
      <Slider {...settings} className="max-w-7xl mx-auto">
        {projects.map((project, index) => (
          <div key={index} className="px-2 mb-10">
            <ProjectCard
              image={project.image}
              title={project.title}
              category={project.category}
              isActive={true}
            />
          </div>
        ))}
      </Slider>

      {/* Custom CSS for Dots */}
      <style>
        {`
          .custom-dots {
            display: flex !important;
            justify-content: center;
            align-items: center;
            gap: 10px; /* Increase spacing between dots */
            margin-top: 30px; /* Increase spacing between dots and projects */
          }
          .custom-dots li {
            transition: all 0.3s ease-in-out;
          }
          .custom-dots li:nth-child(n+4) {
            display: none !important;
          }
          .custom-dots li.slick-active div {
            width: 20px;
          }
        `}
      </style>
    </div>
  );
};

export default Projects;
