import Navbar from "@/components/common/navbar/Navbar";
import { Outlet, ScrollRestoration } from "react-router-dom";
import Footer from "@/components/common/footer/Footer";

const MainLayout = () => {
    return (
        <>
            <Navbar />
            <div className="body-height">
                <Outlet />
            </div>
            <Footer />
            <ScrollRestoration />
        </>
    );
};

export default MainLayout;