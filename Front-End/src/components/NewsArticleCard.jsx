import React from "react";
import { User, MessageCircle } from "lucide-react"; // Import icons from Lucide React

const NewsArticleCard = ({ image, title, author, date, comments }) => {
  return (
    <div className="bg-[#1a2e1b] rounded-2xl shadow-lg overflow-hidden max-w-sm mx-auto sm:max-w-md md:max-w-lg lg:max-w-xl cursor-pointer transition-transform duration-300 hover:scale-105">
      <div className="relative">
        <img
          src={image}
          alt={title}
          className="w-full h-56 sm:h-64 md:h-72 lg:h-80 object-cover"
        />
        <div className="absolute bottom-3 right-3 bg-[#F7C35F] text-xs sm:text-sm px-2 sm:px-3 py-1 rounded-md font-semibold">
          {date}
        </div>
      </div>
      <div className="p-4 sm:p-5 md:p-6">
        <p className="text-gray-400 text-xs sm:text-sm flex items-center gap-4">
          <span className="flex items-center gap-1">
            <User size={16} className="text-[#F7C35F]" />
            <span className="font-semibold">{author}</span>
          </span>
          <span className="flex items-center gap-1">
            <MessageCircle size={16} className="text-[#F7C35F]" />
            <span>{comments} Comments</span>
          </span>
        </p>
        <h3 className="text-white text-base sm:text-lg md:text-xl font-bold mt-2">
          {title}
        </h3>
      </div>
    </div>
  );
};

export default NewsArticleCard;
