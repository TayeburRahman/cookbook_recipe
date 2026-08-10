import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuGroup, DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { Skeleton } from "@/components/ui/skeleton";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Heart, LogIn, LogOutIcon, Moon, Sun, User, UserPlus } from "lucide-react";
import { useTheme } from "@/theme/theme-provider";
import { Link } from "react-router-dom";
import { getInitials } from "@/lib/utils";

const MobileDropdown = ({isLoading, isLoggedIn, user, handleLogout}) => {
    const { setTheme, theme } = useTheme();
    return (
        <>
            <DropdownMenu>
                <DropdownMenuTrigger asChild>
                    {isLoading ? (
                        <Skeleton className="h-10 w-10 rounded-full" />
                    ) : isLoggedIn ? (
                        <Avatar className="h-10 w-10 border">
                            <AvatarImage src={user?.profile_image} alt={user?.name || "User avatar"} />
                            <AvatarFallback>{getInitials(user?.name)}</AvatarFallback>
                        </Avatar>
                    ) : (
                        <Button variant="ghost" size="icon" className="h-10 w-10 rounded-full">
                            <User className="h-5 w-5" />
                        </Button>
                    )}
                </DropdownMenuTrigger>
                <DropdownMenuContent className="max-w-64 mr-4">
                    {isLoading ? (
                        <div className="p-2 min-w-[200px]">
                            <Skeleton className="h-4 w-28 rounded mb-2" />
                            <Skeleton className="h-3 w-40 rounded" />
                        </div>
                    ) : isLoggedIn ? (
                        <>
                            <DropdownMenuLabel className="flex min-w-0 flex-col">
                                <span className="text-foreground truncate text-sm font-medium">
                                    {user?.name || "User"}
                                </span>
                                <span className="text-muted-foreground truncate text-xs font-normal">
                                    {user?.email || ""}
                                </span>
                            </DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuGroup>
                                <DropdownMenuItem asChild>
                                    <Link to="/profile" className="w-full flex items-center">
                                        <User size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                        <span>Account</span>
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem asChild>
                                    <Link to="/profile/my-favourite" className="w-full flex items-center">
                                        <Heart size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                        <span>Favourite</span>
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem asChild>
                                    <Link to="/profile/my-recipes" className="w-full flex items-center">
                                        <Heart size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                        <span>Recipe</span>
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
                                    {theme === 'dark' ? <Sun size={16} className="opacity-60 mr-2" /> : <Moon size={16} className="opacity-60 mr-2" />}
                                    <span>{theme === "dark" ? "Light Mode" : "Dark Mode"}</span>
                                </DropdownMenuItem>
                            </DropdownMenuGroup>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem onClick={handleLogout}>
                                <LogOutIcon size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                <span>Logout</span>
                            </DropdownMenuItem>
                        </>
                    ) : (
                        <DropdownMenuGroup>
                            <DropdownMenuItem asChild>
                                <Link to="/login" className="w-full flex items-center">
                                    <LogIn size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                    <span>Login</span>
                                </Link>
                            </DropdownMenuItem>
                            <DropdownMenuItem asChild>
                                <Link to="/register" className="w-full flex items-center">
                                    <UserPlus size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                    <span>Register</span>
                                </Link>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
                                {theme === 'dark' ? <Sun size={16} className="opacity-60 mr-2" /> : <Moon size={16} className="opacity-60 mr-2" />}
                                <span>{theme === "dark" ? "Light Mode" : "Dark Mode"}</span>
                            </DropdownMenuItem>
                        </DropdownMenuGroup>
                    )}
                </DropdownMenuContent>
            </DropdownMenu>
        </>
    );
};

export default MobileDropdown;