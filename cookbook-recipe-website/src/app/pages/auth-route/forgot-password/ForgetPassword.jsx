import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { ArrowLeft } from "lucide-react";
import { Link } from "react-router-dom";
import { useForgetPasswordMutation } from "@/redux/feature/auth/authApi";

const forgotPasswordSchema = z.object({
    email: z.string().min(1, { message: "Email is required." }).email({ message: "Invalid email address." }),
});

const ForgetPassword = () => {
    const form = useForm({
        resolver: zodResolver(forgotPasswordSchema),
        defaultValues: {
            email: "",
        },
    });

    const [forgetPassword, { isLoading }] = useForgetPasswordMutation()

    const onSubmit = (data) => {
        forgetPassword(data)
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
                                    <h1 className="text-2xl font-semibold text-title mb-2">Forgot Your Password?</h1>
                                    <p className="text-sm text-subtitle">Enter your email to reset your password.</p>
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

                                <Button type="submit" className="w-full" loading={isLoading}>
                                    Get Code
                                </Button>
                            </div>
                        </form>
                    </Form>
                </CardContent>
            </Card>
        </div>
    )
}

export default ForgetPassword;