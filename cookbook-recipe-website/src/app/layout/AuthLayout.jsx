import { Outlet } from "react-router-dom";
import PublicRoute from "@/tools/PublicRoute";

const AuthLayout = () => {
    return (
        <div className="h-screen flex flex-col justify-center items-center">
            <PublicRoute>
                <Outlet />
            </PublicRoute>
        </div>
    );
};

export default AuthLayout;