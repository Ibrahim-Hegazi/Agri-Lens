import React from "react";
import NewsArticleCard from "../components/NewsArticleCard";
import News1 from "../assets/news1.png";
import News2 from "../assets/news2.png";
import News3 from "../assets/news3.png";

const articles = [
  {
    image: News1,
    title: "Taking seamless key indicators",
    author: "Mohamed Tharwat",
    date: "3 Sep, 2023",
    comments: 2,
  },
  {
    image: News2,
    title: "Provide more additional services",
    author: "Mohamed Tharwat",
    date: "3 Sep, 2023",
    comments: 5,
  },
  {
    image: News3,
    title: "Agriculture Matters to the Future of next",
    author: "Mohamed Tharwat",
    date: "3 Sep, 2023",
    comments: 1,
  },
];

const News = () => {
  return (
    <div className="min-h-screen flex flex-col">
      {/* Upper Half - Dark Green Background */}
      <section className="bg-[#1D3B26] flex flex-col justify-center items-center h-1/2 py-16 px-6 text-center">
        <p className="text-gray-400 uppercase text-xs sm:text-sm font-[century_gothic] tracking-wide">
          From the blog
        </p>
        <h2
          className="text-white font-bold mt-2 text-3xl sm:text-4xl md:text-5xl"
          style={{
            fontFamily: "Livvic",
            fontWeight: 700,
            lineHeight: "1.2",
          }}
        >
          News & Articles
        </h2>
      </section>

      {/* Lower Half - Light Gray Background */}
      <section className="bg-[#263C28] flex-grow py-16 px-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 justify-center">
          {articles.map((article, index) => (
            <NewsArticleCard key={index} {...article} />
          ))}
        </div>
      </section>
    </div>
  );
};

export default News;
