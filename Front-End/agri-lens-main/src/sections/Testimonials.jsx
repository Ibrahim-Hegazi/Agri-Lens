import React, { useState } from "react";
import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";
import TestimonialCard from "../components/TestimonialCard"; // Reusable component
import Customer from "../assets/customer.jpg"; // Image

const testimonials = [
  {
    name: "Mohamed Tharwat",
    role: "Customer",
    text: "Agri Lens has completely transformed the way we manage our crops. With AI-powered disease detection and smart irrigation, we've seen a 30% increase in yield while using less water and fertilizers!",
    image: Customer,
  },
  {
    name: "Amina Hassan",
    role: "Farmer",
    text: "This smart farming system has significantly improved my yield. Highly recommended!",
    image: Customer,
  },
  {
    name: "Ali Ahmed",
    role: "Agriculture Expert",
    text: "The AI-driven insights helped me optimize soil nutrition effectively.",
    image: Customer,
  },
];

const Testimonials = () => {
  const [currentSlide, setCurrentSlide] = useState(0);

  const settings = {
    dots: true,
    infinite: true,
    speed: 500,
    slidesToShow: 1, // One testimonial per slide
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
    arrows: false,
    beforeChange: (oldIndex, newIndex) => setCurrentSlide(newIndex),
    customPaging: (i) => (
      <div
        className={`w-3 h-3 rounded-full transition-all duration-300 ${
          i === currentSlide % testimonials.length
            ? "bg-[#F7C35F] w-5"
            : "bg-gray-400"
        }`}
      ></div>
    ),
    dotsClass: "slick-dots custom-dots",
  };

  return (
    <section className="bg-[#1D3B26] py-16 px-4 sm:px-6 md:px-8 lg:px-10 xl:px-12">
      {/* Section Heading */}
      <div className="text-center text-white mb-10">
        <p className="text-xs sm:text-sm uppercase font-[century_gothic] tracking-wide text-gray-400">
          Our Testimonials
        </p>
        <h2
          className="font-livvic font-bold text-[50px] leading-[62.75px] tracking-0 mt-2"
          style={{ fontFamily: "Livvic", fontWeight: 700 }}
        >
          What They&apos;re Talking About
        </h2>
      </div>

      {/* Testimonial Carousel */}
      <div className="max-w-3xl mx-auto">
        <Slider {...settings}>
          {testimonials.map((testimonial, index) => (
            <div key={index} className="px-2">
              <TestimonialCard {...testimonial} />
            </div>
          ))}
        </Slider>
      </div>

      {/* Custom Styling for Dots */}
      <style>
        {`
          .custom-dots {
            display: flex !important;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
          }
          .custom-dots li {
            transition: all 0.3s ease-in-out;
          }
          .custom-dots li.slick-active div {
            width: 20px;
          }
        `}
      </style>
    </section>
  );
};

export default Testimonials;
