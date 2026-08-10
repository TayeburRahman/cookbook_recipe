import { useState, useEffect } from "react"
import { Heart, Home, Book, Calendar, ShoppingCart, Star, Info, Moon, Sun, Mail } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Toggle } from "@/components/ui/toggle"
import { NavLink, Link } from "react-router-dom"
import Logo from '../../../assets/Logo.png';
import { useTheme } from "@/theme/theme-provider"
import MobileMenu from "./MobileMenu"
import MobileDropdown from "./MobileDropdown"
import DesktopDropdown from "./DesktopDropdown"
import { useDispatch, useSelector } from "react-redux"
import { useGetUserProfileQuery } from "@/redux/feature/profile/profileApi"
import { Logout } from "@/redux/feature/auth/authSlice"

const navigationItems = [
    { name: "Home", href: "/", icon: Home },
    { name: "Recipes", href: "/recipes", icon: Book },
    { name: "Meal Planner", href: "/meal-planner", icon: Calendar },
    { name: "Grocery", href: "/grocery", icon: ShoppingCart },
    { name: "Featured", href: "/featured", icon: Star },
    { name: "About", href: "/about", icon: Info },
    { name: "Contact", href: "/contact", icon: Mail },
]

const Navbar = () => {
    const { setTheme, theme } = useTheme();
    const dispatch = useDispatch();

    const [lastScrollY, setLastScrollY] = useState(0);
    const [isVisible, setIsVisible] = useState(true);

    useEffect(() => {
        const handleScroll = () => {
            if (window.scrollY > lastScrollY && window.scrollY > 100) {
                setIsVisible(false);
            } else {
                setIsVisible(true);
            }
            setLastScrollY(window.scrollY);
        };

        window.addEventListener('scroll', handleScroll);

        return () => {
            window.removeEventListener('scroll', handleScroll);
        };
    }, [lastScrollY]);

    const token = useSelector((state) => state.auth.accessToken);
    const { isLoading } = useGetUserProfileQuery(undefined, {
        skip: !token // Skip the query if there's no token
    });
    const user = useSelector((state) => state.profile.userProfile);
    const isLoggedIn = !!token;


    // Mock logout function
    const handleLogout = () => {
        dispatch(Logout());
        window.location.href = "/";
    };

    return (
        <nav className={`sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 transition-transform duration-300 ${isVisible ? 'translate-y-0' : '-translate-y-full'}`}>
            <div className="container max-w-7xl mx-auto px-4 xl:px-0">
                <div className="flex h-20 items-center justify-between">
                    {/* Logo */}
                    <div className="flex items-center space-x-8">
                        <Link to="/" className="flex items-center space-x-2">
                            <div className="h-12 w-12">
                                <img src={Logo} alt="Logo" className="h-full w-full rounded-full object-contain dark:brightness-150" />
                            </div>
                        </Link>

                        {/* Desktop Navigation */}
                        <div className="hidden lg:flex items-center space-x-8">
                            {navigationItems.map((item) => (
                                <NavLink
                                    key={item.name}
                                    to={item.href}
                                    className={({ isActive }) =>
                                        `text-sm font-medium transition-colors hover:text-foreground ${isActive ? 'text-foreground' : 'text-muted-foreground'
                                        }`
                                    }
                                >
                                    {item.name}
                                </NavLink>
                            ))}
                        </div>
                    </div>

                    {/* Right Section */}
                    <div className="flex items-center gap-4">
                        {/* Theme Toggle */}
                        <Toggle size="sm"
                            variant="ghost"
                            className="group rounded-full hidden md:flex"
                            pressed={theme === "dark"}
                            onPressedChange={() =>
                                setTheme(theme === "dark" ? "light" : "dark")
                            }
                            aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
                        >
                            <Moon
                                className="shrink-0 scale-0 opacity-0 transition-all group-data-[state=on]:scale-100 group-data-[state=on]:opacity-100"
                                aria-hidden="true"
                            />
                            <Sun
                                className="absolute shrink-0 scale-100 opacity-100 transition-all group-data-[state=on]:scale-0 group-data-[state=on]:opacity-0"
                                aria-hidden="true"
                            />
                        </Toggle>
                        {/* Heart Icon */}
                        <Link to="/profile/my-favourite">
                            <Button variant="ghost" size="icon" className="hidden rounded-full md:flex">
                                <Heart className="h-5 w-5" />
                                <span className="sr-only">Favorites</span>
                            </Button>
                        </Link>

                        {/* Desktop User Profile (md and up) */}
                        <div className="hidden md:flex items-center space-x-2">
                            <DesktopDropdown {...{ isLoading, isLoggedIn, user, handleLogout }} />
                        </div>

                        {/* Mobile User Profile (below md) */}
                        <div className="md:hidden">
                            <MobileDropdown {...{ isLoading, isLoggedIn, user, handleLogout }} />
                        </div>

                        {/* Mobile Menu */}
                        <MobileMenu {...{ navigationItems, user }} />
                    </div>
                </div>
            </div>
        </nav>
    )
}

export default Navbar;