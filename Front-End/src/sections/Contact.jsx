import React from "react";

const Contact = () => {
  return (
    <div className="bg-[#263C28] text-white py-16 px-6 sm:px-12 md:px-24 lg:px-32 flex flex-col md:flex-row items-center justify-between gap-12">
      {/* Left Side: Contact Info */}
      <div className="w-full md:w-1/2 space-y-8 text-center md:text-left">
        <p className="text-sm uppercase tracking-widest text-gray-300 font-[century_gothic]">
          Contact Now
        </p>
        <h2 className="text-5xl font-bold leading-tight font-[livvic]">
          GET IN TOUCH NOW
        </h2>
        <p className="text-gray-400 text-lg leading-relaxed">
          We’re here to help! Whether you have questions, need more information,
          or want to collaborate, feel free to reach out. Our team is ready to
          assist you with all your agricultural needs.
        </p>

        <div className="space-y-6">
          <div>
            <p className="uppercase text-sm font-semibold text-gray-300">
              Phone
            </p>
            <p className="text-lg font-bold">01205207376</p>
          </div>

          <div>
            <p className="uppercase text-sm font-semibold text-gray-300">
              Email
            </p>
            <p className="text-lg">acc.motharwat@gmail.com</p>
          </div>

          <div>
            <p className="uppercase text-sm font-semibold text-gray-300">
              Address
            </p>
            <p className="text-lg">Mansoura</p>
          </div>
        </div>
      </div>

      {/* Right Side: Form */}
      <div className="w-full md:w-1/2">
        <form className="space-y-6">
          <input
            type="text"
            placeholder="Your Name"
            className="w-full p-4 bg-[#1d2b1f] text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-[#F7C35F] transition-all"
          />
          <input
            type="text"
            placeholder="Phone Number"
            className="w-full p-4 bg-[#1d2b1f] text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-[#F7C35F] transition-all"
          />
          <input
            type="email"
            placeholder="Your Email"
            className="w-full p-4 bg-[#1d2b1f] text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-[#F7C35F] transition-all"
          />
          <textarea
            placeholder="Your Message"
            className="w-full p-4 bg-[#1d2b1f] text-white rounded-lg h-40 focus:outline-none focus:ring-2 focus:ring-[#F7C35F] transition-all"
          ></textarea>

          <button
            type="submit"
            className="w-full md:w-auto bg-[#F7C35F] text-black px-8 py-4 rounded-lg font-semibold hover:bg-black hover:text-[#F7C35F] cursor-pointer transition-all"
          >
            SEND MESSAGE
          </button>
        </form>
      </div>
    </div>
  );
};

export default Contact;
