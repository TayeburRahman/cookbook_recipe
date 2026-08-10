import { useSelector } from "react-redux";
import { Navigate, useLocation } from "react-router-dom";

const PrivateRoute = ({ children }) => {
    const location = useLocation();
    const { accessToken } = useSelector((state) => state.auth);
    
    if (!accessToken) {
        return <Navigate to="/login" state={{ from: location }} />;
    }
    return children;
};

export default PrivateRoute;