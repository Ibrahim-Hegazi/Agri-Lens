import Navbar from "./components/Navbar";
import Home from "./sections/Home";
import About from "./sections/About";
import Products from "./sections/Products";
import Projects from "./sections/Projects";
import Services from "./sections/Services";
import News from "./sections/News";
import Contact from "./sections/Contact";
import Video from "./sections/Video";
import Testimonials from "./sections/Testimonials";
import Download from "./sections/Download";
import Footer from "./sections/Footer";

function App() {
  return (
    <div>
      <Navbar />

      {/* Sections */}
      <section id="home">
        <Home />
      </section>
      <section id="about">
        <About />
      </section>
      <section id="products">
        <Products />
      </section>
      <section>
        <Video />
      </section>
      <section id="projects">
        <Projects />
      </section>
      <section id="testimonials">
        <Testimonials />
      </section>
      <section id="services">
        <Services />
      </section>
      <section id="news">
        <News />
      </section>
      <section id="contact">
        <Contact />
      </section>
      <section>
        <Download />
      </section>
      <Footer />
    </div>
  );
}

export default App;
