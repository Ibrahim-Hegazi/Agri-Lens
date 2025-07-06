import { FaFacebookF, FaTwitter, FaYoutube, FaInstagram } from "react-icons/fa";
import { Link } from "react-scroll";

const Footer = () => {
  return (
    <footer className="bg-[#263C28] text-gray-300 py-10 px-8 md:px-16 lg:px-32">
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center border-b border-gray-700 pb-8">
        {/* Left Section */}
        <div className="mb-6 md:mb-0">
          <h2 className="text-6xl font-[passions_conflict] text-white">
            Agri Lens
          </h2>
          <p className="mt-2 max-w-xs text-sm text-gray-400">
            Agri Lens is committed to revolutionizing modern agriculture with
            smart farming solutions. Our goal is to help farmers optimize
            yields, manage resources efficiently, and ensure sustainable farming
            practices through cutting-edge technology.
          </p>
          <div className="flex space-x-4 mt-4">
            <FaFacebookF className="text-[#F4B860] cursor-pointer" />
            <FaYoutube className="text-[#F4B860] cursor-pointer" />
            <FaInstagram className="text-[#F4B860] cursor-pointer" />
          </div>
        </div>

        {/* Middle Section */}
        <div className="mb-6 md:mb-0">
          <h3 className="text-white font-semibold text-lg mb-3">
            Useful Links
          </h3>
          <ul className="space-y-2 text-sm text-gray-400">
            <li>
              <Link
                to="projects"
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-white"
              >
                New Projects
              </Link>
            </li>
            <li>
              <Link
                to="services"
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-white"
              >
                Our Services
              </Link>
            </li>
            <li>
              <Link
                to="testimonials"
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-white"
              >
                Testimonials
              </Link>
            </li>
            <li>
              <Link
                to="about"
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-white"
              >
                About Us
              </Link>
            </li>
            <li>
              <Link
                to="contact"
                smooth={true}
                duration={500}
                className="cursor-pointer hover:text-white"
              >
                Contact Us
              </Link>
            </li>
          </ul>
        </div>

        {/* Right Section */}
        <div>
          <h3 className="text-white font-semibold text-lg mb-3">Newsletter</h3>
          <p className="text-sm text-gray-400 mb-3">
            Subscribe to our weekly Newsletter and receive updates via email.
          </p>
          <div className="flex items-center bg-green-900 rounded-full overflow-hidden">
            <input
              type="email"
              placeholder="Enter your mail here..."
              className="bg-transparent text-sm px-4 py-2 w-full text-white focus:outline-none"
            />
            <button className="bg-[#F4B860] text-black font-semibold cursor-pointer px-4 py-2">
              GO
            </button>
          </div>
        </div>
      </div>

      {/* Bottom Section */}
      <div className="flex flex-col md:flex-row justify-between items-center mt-6 text-gray-400 text-xs">
        <p>Copyright © Agri Lens. All Rights Reserved.</p>
        <div className="flex space-x-4 mt-2 md:mt-0">
          <span className="cursor-pointer hover:text-white">
            Terms & Conditions
          </span>
          <span className="cursor-pointer hover:text-white">
            Privacy Policy
          </span>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
