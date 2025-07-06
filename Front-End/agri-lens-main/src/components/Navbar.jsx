import { useState, useEffect } from "react";
import { Link } from "react-scroll";
import { Menu, X } from "lucide-react";
import Logo from "../assets/logo.png";

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [activeSection, setActiveSection] = useState("home");

  useEffect(() => {
    // Detect which section is in view
    const handleScroll = () => {
      const sections = [
        "home",
        "about",
        "products",
        "projects",
        "services",
        "news",
        "contact",
      ];
      for (let section of sections) {
        const element = document.getElementById(section);
        if (element) {
          const rect = element.getBoundingClientRect();
          if (rect.top >= -100 && rect.top <= window.innerHeight / 2) {
            setActiveSection(section);
            break;
          }
        }
      }
    };

    window.addEventListener("scroll", handleScroll);
    handleScroll(); // Run once to set the initial active section
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <nav className="fixed top-0 w-full bg-[#2F402A] shadow-md p-4 flex justify-between items-center px-6 md:px-10 z-50">
      {/* Logo & Brand Name */}
      <div className="flex items-center">
        <Link to="home" smooth={true} duration={500} className="flex items-center cursor-pointer">
          <img src={Logo} alt="Logo" className="h-12 w-12 mr-3" />
          <span className="text-white font-['Passions_Conflict'] text-3xl">
            Agri Lens
          </span>
        </Link>
      </div>

      {/* Desktop Navigation Links */}
      <div className="hidden md:flex space-x-6 lg:space-x-8 pr-5">
        {[
          { to: "home", label: "Home" },
          { to: "about", label: "About Us" },
          { to: "products", label: "Our Products" },
          { to: "projects", label: "Projects" },
          { to: "services", label: "Services" },
          { to: "news", label: "News" },
          { to: "contact", label: "Contact Us" },
        ].map((link) => (
          <div key={link.to} className="relative group">
            <Link
              to={link.to}
              smooth={true}
              duration={500}
              className={`relative cursor-pointer text-lg font-light ${
                activeSection === link.to
                  ? "text-white"
                  : "text-gray-300 hover:text-white"
              }`}
            >
              {link.label}
              {/* Underline Effect */}
              <span
                className={`absolute left-0 bottom-[-6px] h-[3px] bg-yellow-400 transition-all duration-300 ease-in-out ${
                  activeSection === link.to
                    ? "w-full"
                    : "w-0 group-hover:w-full"
                }`}
              ></span>
            </Link>
          </div>
        ))}
      </div>

      {/* Mobile Menu Button */}
      <button
        className="md:hidden text-white cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        {isOpen ? <X size={28} /> : <Menu size={28} />}
      </button>

      {/* Mobile Navigation Menu */}
      <div
        className={`absolute top-16 left-0 w-full bg-[#2F402A] shadow-md md:hidden transition-all duration-300 ${
          isOpen ? "block" : "hidden"
        }`}
      >
        <ul className="flex flex-col items-center space-y-6 py-6">
          {[
            { to: "home", label: "Home" },
            { to: "about", label: "About Us" },
            { to: "products", label: "Our Products" },
            { to: "projects", label: "Projects" },
            { to: "services", label: "Services" },
            { to: "news", label: "News" },
            { to: "contact", label: "Contact Us" },
          ].map((link) => (
            <li key={link.to} className="relative">
              <Link
                to={link.to}
                smooth={true}
                duration={500}
                className={`text-xl font-medium cursor-pointer ${
                  activeSection === link.to
                    ? "text-white"
                    : "text-gray-300 hover:text-white"
                }`}
                onClick={() => setIsOpen(false)}
              >
                {link.label}
                {/* Underline Effect */}
                <span
                  className={`absolute left-0 bottom-[-6px] h-[3px] bg-yellow-400 transition-all duration-300 ease-in-out ${
                    activeSection === link.to ? "w-full" : "w-0 hover:w-full"
                  }`}
                ></span>
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </nav>
  );
};

export default Navbar;
