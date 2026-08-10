import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuGroup, DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { LogIn, LogOutIcon, User, UserPlus } from "lucide-react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { getInitials } from "@/lib/utils";

const DesktopDropdown = ({ isLoading, isLoggedIn, user, handleLogout }) => {
    return (
        <>
            {isLoggedIn ? (
                <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                        {
                            isLoading ? (
                                <div className="flex items-center space-x-2 cursor-pointer">
                                    <Skeleton className="h-10 w-10 border rounded-full"/>
                                    <Skeleton className="w-24 h-4"></Skeleton>
                                </div>
                            ) : (
                                <div className="flex items-center space-x-2 cursor-pointer">
                                    <Avatar className="h-10 w-10 border">
                                        <AvatarImage src={user?.profile_image} alt={user?.name || "User avatar"} />
                                        <AvatarFallback>{getInitials(user?.name)}</AvatarFallback>
                                    </Avatar>
                                    <span className="text-sm font-medium">{user?.name || "User"}</span>
                                </div>
                            )
                        }
                    </DropdownMenuTrigger>
                    <DropdownMenuContent className="max-w-64 mr-4">
                        {isLoading ? (
                            <div className="p-2 min-w-[200px]">
                                <Skeleton className="h-4 w-28 rounded mb-2" />
                                <Skeleton className="h-3 w-40 rounded" />
                            </div>
                        ) : (
                            <DropdownMenuLabel className="flex min-w-0 flex-col">
                                <span className="text-foreground truncate text-sm font-medium">
                                    {user?.name || "User"}
                                </span>
                                <span className="text-muted-foreground truncate text-xs font-normal">
                                    {user?.email || ""}
                                </span>
                            </DropdownMenuLabel>
                        )}
                        <DropdownMenuSeparator />
                        <DropdownMenuGroup>
                            <DropdownMenuItem asChild>
                                <Link to="/profile" className="w-full flex items-center">
                                    <User size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                    <span>Profile</span>
                                </Link>
                            </DropdownMenuItem>
                        </DropdownMenuGroup>
                        <DropdownMenuSeparator />
                        <DropdownMenuItem onClick={handleLogout}>
                            <LogOutIcon size={16} className="opacity-60 mr-2" aria-hidden="true" />
                            <span>Logout</span>
                        </DropdownMenuItem>
                    </DropdownMenuContent>
                </DropdownMenu>
            ) : (
                <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon" className="h-10 w-10 rounded-full">
                            <User className="h-5 w-5" />
                        </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent className="max-w-64 mr-4">
                        <DropdownMenuItem asChild>
                            <Link to="/auth/login" className="w-full flex items-center">
                                <LogIn size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                <span>Login</span>
                            </Link>
                        </DropdownMenuItem>
                        <DropdownMenuItem asChild>
                            <Link to="/auth/register" className="w-full flex items-center">
                                <UserPlus size={16} className="opacity-60 mr-2" aria-hidden="true" />
                                <span>Sign Up</span>
                            </Link>
                        </DropdownMenuItem>
                    </DropdownMenuContent>
                </DropdownMenu>
            )}
        </>
    );
};

export default DesktopDropdown;