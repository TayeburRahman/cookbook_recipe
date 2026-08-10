import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { ArrowLeft, Eye, EyeOff } from "lucide-react";
import { Link } from "react-router-dom";
import { useResetPasswordMutation } from "@/redux/feature/auth/authApi";

const resetPasswordSchema = z.object({
    newPassword: z.string().min(6, { message: "New password must be at least 6 characters." }),
    confirmNewPassword: z.string().min(6, { message: "Confirm new password must be at least 6 characters." }),
}).refine((data) => data.newPassword === data.confirmNewPassword, {
    message: "Passwords don't match.",
    path: ["confirmNewPassword"],
});

const ResetPassword = () => {
    const email = new URLSearchParams(window.location.search).get("email");
    const [showNewPassword, setShowNewPassword] = useState(false);
    const [showConfirmNewPassword, setShowConfirmNewPassword] = useState(false);
    const toggleNewPasswordVisibility = () => setShowNewPassword(!showNewPassword);
    const toggleConfirmNewPasswordVisibility = () => setShowConfirmNewPassword(!showConfirmNewPassword);

    const [resetPassword, { isLoading }] = useResetPasswordMutation();

    const form = useForm({
        resolver: zodResolver(resetPasswordSchema),
        defaultValues: {
            newPassword: "",
            confirmNewPassword: "",
        },
    });

    const onSubmit = (data) => {
        const payload = {
            newPassword: data.newPassword,
            confirmPassword: data.confirmNewPassword,
            email
        }
        resetPassword(payload)
    };

    return (
        <div className="w-full max-w-sm md:max-w-lg">
            <Card className="overflow-hidden p-0">
                <CardContent className="p-0">
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="p-6 md:p-8">
                            <Link to="/auth/login">
                                <ArrowLeft className="cursor-pointer" />
                            </Link>
                            <div className="flex flex-col gap-6 mt-6">
                                <div className="flex flex-col items-center text-center">
                                    <h1 className="text-2xl font-semibold text-title">Reset Your Password</h1>
                                    <p className="text-sm text-subtitle">Enter your new password below.</p>
                                </div>

                                <FormField
                                    control={form.control}
                                    name="newPassword"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>New Password</FormLabel>
                                            <FormControl>
                                                <div className="relative">
                                                    <Input
                                                        type={showNewPassword ? "text" : "password"}
                                                        placeholder="********"
                                                        {...field}
                                                    />
                                                    <button
                                                        type="button"
                                                        className="absolute inset-y-0 right-0 flex items-center px-3 text-primary cursor-pointer"
                                                        onClick={toggleNewPasswordVisibility}
                                                    >
                                                        {showNewPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                                                    </button>
                                                </div>
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="confirmNewPassword"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Confirm New Password</FormLabel>
                                            <FormControl>
                                                <div className="relative">
                                                    <Input
                                                        type={showConfirmNewPassword ? "text" : "password"}
                                                        placeholder="********"
                                                        {...field}
                                                    />
                                                    <button
                                                        type="button"
                                                        className="absolute inset-y-0 right-0 flex items-center px-3 text-primary cursor-pointer"
                                                        onClick={toggleConfirmNewPasswordVisibility}
                                                    >
                                                        {showConfirmNewPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                                                    </button>
                                                </div>
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <Button loading={isLoading} type="submit" className="w-full" >
                                    Reset Password
                                </Button>
                            </div>
                        </form>
                    </Form>
                </CardContent>
            </Card>
        </div>
    )
}

export default ResetPassword;