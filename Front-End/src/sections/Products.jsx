import Apple from "../assets/Icon_Apple.png";
import Blueberry from "../assets/Icon_Blueberry.png";
import Strawberry from "../assets/Icon_Strawberry.png";
import Cabbage from "../assets/Icon_Cabbage.png";
import Carrot from "../assets/Icon_Carrot.png";

const products = [
  { name: "Apple", image: Apple },
  { name: "Blueberry", image: Blueberry },
  { name: "Strawberry", image: Strawberry },
  { name: "Cabbage", image: Cabbage },
  { name: "Carrot", image: Carrot },
];

const Products = () => {
  return (
    <div className="flex flex-col items-center py-16 px-6 bg-[#2F402A] text-white">
      {/* Title Section */}
      <h3 className="text-xs sm:text-sm uppercase tracking-wide text-gray-400 text-center">
        Popular Foods and Vegetables
      </h3>
      <h2 className="text-2xl sm:text-3xl font-bold mt-2 border-b-2 border-[#F7C35F] pb-2 px-4 text-center">
        Focus On & Future
      </h2>

      {/* Product Grid */}
      <div className="mt-10 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6 sm:gap-10 mb-10">
        {products.map((product) => (
          <div
            key={product.name}
            className={`flex flex-col items-center w-28 sm:w-36 md:w-40 lg:w-48 h-28 sm:h-36 md:h-40 lg:h-48 p-4 sm:p-6 rounded-xl text-center
              ${
                product.name === "Strawberry"
                  ? "bg-[#F7C35F] text-black shadow-lg scale-105"
                  : "bg-[rgba(217,217,217,0.1)] text-white opacity-50 cursor-not-allowed"
              }`}
          >
            <img
              src={product.image}
              alt={product.name}
              className="w-10 sm:w-12 md:w-16 h-10 sm:h-12 md:h-16"
            />
            <p className="mt-3 sm:mt-4 text-sm sm:text-lg font-semibold">
              {product.name}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Products;
