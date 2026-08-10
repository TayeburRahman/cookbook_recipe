import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Link } from "react-router-dom";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { ArrowLeft, Eye, EyeOff } from "lucide-react";
import { useLoginMutation } from "@/redux/feature/auth/authApi";

const loginSchema = z.object({
    email: z.string().min(1, { message: "Email is required." }).email({ message: "Invalid email address." }),
    password: z.string().min(6, { message: "Password must be at least 6 characters." }),
});

const LoginForm = () => {
    const [showPassword, setShowPassword] = useState(false);
    const togglePasswordVisibility = () => setShowPassword(!showPassword);
    const [login, { isLoading }] = useLoginMutation();

    const form = useForm({
        resolver: zodResolver(loginSchema),
        defaultValues: {
            email: "",
            password: "",
        },
    });

    const onSubmit = (data) => {
        login(data);
    };

    return (
        <div className="w-full max-w-sm md:max-w-lg">
            <Card className="overflow-hidden p-0">
                <CardContent className="p-0">
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="p-6 md:p-8">
                            <Link to="/">
                                <ArrowLeft className="cursor-pointer" />
                            </Link>
                            <div className="flex flex-col gap-6 mt-6">
                                <div className="flex flex-col items-center text-center">
                                    <h1 className="text-2xl font-semibold text-title">Welcome back</h1>
                                </div>
                                <FormField
                                    control={form.control}
                                    name="email"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Email</FormLabel>
                                            <FormControl>
                                                <Input
                                                    type="email"
                                                    placeholder="Enter your email"
                                                    {...field}
                                                />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="password"
                                    render={({ field }) => (
                                        <FormItem>
                                            <div className="flex items-center">
                                                <FormLabel>Password</FormLabel>
                                                <Link
                                                    to="/auth/forgot-password"
                                                    className="ml-auto text-sm underline-offset-2 hover:underline"
                                                >
                                                    Forgot your password?
                                                </Link>
                                            </div>
                                            <FormControl>
                                                <div className="relative">
                                                    <Input
                                                        type={showPassword ? "text" : "password"}
                                                        placeholder="********"
                                                        {...field}
                                                    />
                                                    <button
                                                        type="button"
                                                        className="absolute inset-y-0 right-0 flex items-center px-3 text-primary cursor-pointer"
                                                        onClick={togglePasswordVisibility}
                                                    >
                                                        {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                                                    </button>
                                                </div>
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <Button loading={isLoading} type="submit" className="w-full">
                                    Login
                                </Button>
                            </div>
                            <div className="text-center text-sm mt-6">
                                Don&apos;t have an account?{" "}
                                <Link to="/auth/register" className="text-primary">
                                    Sign up
                                </Link>
                            </div>
                        </form>
                    </Form>
                </CardContent>
            </Card>
        </div>
    )
}

export default LoginForm;