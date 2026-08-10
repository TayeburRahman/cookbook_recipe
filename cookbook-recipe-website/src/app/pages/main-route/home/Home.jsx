
import HeroCarousel from "@/components/common/hero/HeroCarousel";
import ClientSays from "@/components/home/ClientSays";
import DietGoals from "@/components/home/DietGoals";
import FeaturedRecipes from "@/components/home/FeaturedRecipes";
// import GetApp from "@/components/home/GetApp";
import TopCategories from "@/components/home/TopCategories";
import Featured from "../featured/Featured";
import { useSelector } from "react-redux";


const Home = () => {

    const { accessToken } = useSelector((state) => state.auth);

    return (
        <>
            {
                accessToken ? (
                    <>
                        <HeroCarousel />
                        <TopCategories />
                        <FeaturedRecipes />
                        <DietGoals />
                        <ClientSays />
                        {/* <GetApp /> */}
                    </>
                ) : (
                    <Featured />
                )
            }
        </>
    );
};

export default Home;