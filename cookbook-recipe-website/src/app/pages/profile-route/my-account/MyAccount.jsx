import { useState, useRef } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import EditAccount from "@/components/account/edit-account/EditAccount";
import ChangePassword from "@/components/account/chagePassword/ChangePassword";
import { useGetUserProfileQuery } from "@/redux/feature/profile/profileApi";
import { useSelector } from "react-redux";
import { getImageUrl, getInitials } from "@/lib/utils";
import { Skeleton } from "@/components/ui/skeleton";

const MyAccount = () => {
    const [activeTab, setActiveTab] = useState("account");
    const fileInputRef = useRef(null);
    const [selectedImage, setSelectedImage] = useState(null);

    const { isLoading } = useGetUserProfileQuery();
    const user = useSelector((state) => state.profile.userProfile);

    const handleFileChange = (event) => {
        const file = event.target.files?.[0];
        if (file) {
            setSelectedImage(file);
        }
    };

    const handleButtonClick = () => {
        fileInputRef.current?.click();
    };

    const avatarSource = selectedImage ? URL.createObjectURL(selectedImage) : getImageUrl(user?.profile_image);

    return (
        <div>
            <input
                type="file"
                ref={fileInputRef}
                onChange={handleFileChange}
                style={{ display: 'none' }}
                accept="image/png, image/jpeg, image/gif"
            />
            <div className="flex flex-col lg:flex-row gap-8">
                {/* Left Sidebar */}
                <div className="w-full lg:w-64 space-y-4">
                    <Card className="shadow-none bg-transparent border">
                        <CardContent className="p-6">
                            {isLoading ? (
                                <div className="flex flex-col items-center space-y-4">
                                    <Skeleton className="h-24 w-24 rounded-full" />
                                    <div className="flex flex-col items-center space-y-2">
                                        <Skeleton className="h-6 w-32" />
                                        <Skeleton className="h-4 w-40" />
                                    </div>
                                    <Skeleton className="h-9 w-full" />
                                </div>
                            ) : (
                                <div className="flex flex-col items-center space-y-4">
                                    <Avatar className="h-24 w-24 border">
                                        <AvatarImage src={avatarSource} />
                                        <AvatarFallback>{getInitials(user?.name)}</AvatarFallback>
                                    </Avatar>
                                    <div className="text-center">
                                        <h2 className="text-xl font-semibold">{user?.name}</h2>
                                        <p className="text-sm font-normal">{user?.email}</p>
                                    </div>
                                    <Button
                                        variant="outline"
                                        className="w-full"
                                        onClick={handleButtonClick}
                                    >
                                        Change Photo
                                    </Button>
                                </div>
                            )}
                        </CardContent>
                    </Card>

                    <Tabs
                        value={activeTab}
                        onValueChange={setActiveTab}
                        className="w-full"
                        orientation="horizontal"
                    >
                        <TabsList className="flex items-center h-auto bg-transparent border p-0.5">
                            <TabsTrigger
                                value="account"
                                className="w-full justify-start data-[state=active]:bg-accent data-[state=active]:shadow-none"
                            >
                                Account
                            </TabsTrigger>
                            <TabsTrigger
                                value="security"
                                className="w-full justify-start data-[state=active]:bg-accent data-[state=active]:shadow-none"
                            >
                                Security
                            </TabsTrigger>
                        </TabsList>
                    </Tabs>
                </div>

                {/* Right Content */}
                <div className="flex-1">
                    <Tabs value={activeTab} className="w-full">
                        {isLoading ? (
                            <Card className="py-6 bg-transparent border">
                                <CardHeader>
                                    <Skeleton className="h-8 w-48" />
                                    <Skeleton className="h-4 w-full max-w-sm" />
                                </CardHeader>
                                <CardContent className="space-y-6">
                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div className="space-y-2">
                                            <Skeleton className="h-4 w-16" />
                                            <Skeleton className="h-10 w-full" />
                                        </div>
                                        <div className="space-y-2">
                                            <Skeleton className="h-4 w-16" />
                                            <Skeleton className="h-10 w-full" />
                                        </div>
                                        <div className="space-y-2">
                                            <Skeleton className="h-4 w-16" />
                                            <Skeleton className="h-10 w-full" />
                                        </div>
                                        <div className="space-y-2">
                                            <Skeleton className="h-4 w-16" />
                                            <Skeleton className="h-10 w-full" />
                                        </div>
                                    </div>
                                    <div className="space-y-2">
                                        <Skeleton className="h-4 w-16" />
                                        <Skeleton className="h-18 w-full" />
                                    </div>
                                    <div className="space-y-2">
                                        <Skeleton className="h-4 w-16" />
                                        <Skeleton className="h-24 w-full" /></div>
                                    <div className="space-y-2">
                                        <Skeleton className="h-4 w-16" />
                                        <Skeleton className="h-24 w-full" />
                                    </div>
                                </CardContent>
                            </Card>
                        ) : (
                            <>
                                <TabsContent value="account">
                                    <EditAccount user={user} newProfileImage={selectedImage} />
                                </TabsContent>

                                <TabsContent value="security">
                                    <ChangePassword />
                                </TabsContent>
                            </>
                        )}
                    </Tabs>
                </div>
            </div>
        </div>
    );
};

export default MyAccount;
