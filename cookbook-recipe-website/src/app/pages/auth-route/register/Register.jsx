import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select"
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Link } from "react-router-dom";
import { useState } from "react";
import { ArrowLeft, Eye, EyeOff, CalendarIcon } from "lucide-react";
import { cn } from "@/lib/utils";
import { format } from "date-fns";
import { useRegisterMutation } from "@/redux/feature/auth/authApi";

const registerSchema = z.object({
    fullname: z.string().min(1, { message: "Full name is required." }),
    email: z.string().min(1, { message: "Email is required." }).email({ message: "Invalid email address." }),
    dob: z.date({
        required_error: "A date of birth is required.",
    }),
    password: z.string().min(6, { message: "Password must be at least 6 characters." }),
});

const Register = () => {
    const [showPassword, setShowPassword] = useState(false);
    const togglePasswordVisibility = () => setShowPassword(!showPassword);

    const form = useForm({
        resolver: zodResolver(registerSchema),
        defaultValues: {
            fullname: "",
            email: "",
            password: "",
        },
    });

    const handleCalendarChange = (value, e) => {
        const event = {
            target: {
                value: String(value),
            },
        }
        e(event)
    }

    const [register, { isLoading }] = useRegisterMutation();

    const onSubmit = (data) => {
        const payload = {
            name: data.fullname,
            role: "USER",
            email: data.email,
            date_of_birth: format(data.dob, "dd-MM-yyyy"),
            password: data.password,
            confirmPassword: data.password,
        }
        console.log(payload)
        register(payload);
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
                                    <h1 className="text-2xl font-semibold text-title">Create an account</h1>
                                    <p className="text-sm text-subtitle">Enter your details below to create your account.</p>
                                </div>

                                <FormField
                                    control={form.control}
                                    name="fullname"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Full Name</FormLabel>
                                            <FormControl>
                                                <Input placeholder="John Doe" {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="email"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Email</FormLabel>
                                            <FormControl>
                                                <Input type="email" placeholder="example@email.com" {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="dob"
                                    render={({ field }) => (
                                        <FormItem className="flex flex-col">
                                            <FormLabel>Date of birth</FormLabel>
                                            <Popover>
                                                <PopoverTrigger asChild>
                                                    <FormControl>
                                                        <Button
                                                            variant={"outline"}
                                                            className={cn(
                                                                "w-full pl-3 text-left font-normal",
                                                                !field.value && "text-muted-foreground"
                                                            )}
                                                        >
                                                            {field.value ? (
                                                                format(field.value, "PPP")
                                                            ) : (
                                                                <span>Pick a date</span>
                                                            )}
                                                            <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                                                        </Button>
                                                    </FormControl>
                                                </PopoverTrigger>
                                                <PopoverContent className="w-auto p-0" align="start">
                                                    <Calendar
                                                        mode="single"
                                                        selected={field.value}
                                                        onSelect={field.onChange}
                                                        className="rounded-md border p-2"
                                                        classNames={{
                                                            month_caption: "mx-0",
                                                        }}
                                                        captionLayout="dropdown"
                                                        defaultMonth={field.value || new Date()}
                                                        fromYear={1900}
                                                        toYear={new Date().getFullYear()}
                                                        hideNavigation
                                                        components={{
                                                            DropdownNav: (props) => {
                                                                return (
                                                                    <div className="flex w-full items-center gap-2">
                                                                        {props.children}
                                                                    </div>
                                                                )
                                                            },
                                                            Dropdown: (props) => {
                                                                return (
                                                                    <Select
                                                                        value={String(props.value)}
                                                                        onValueChange={(value) => {
                                                                            if (props.onChange) {
                                                                                handleCalendarChange(value, props.onChange)
                                                                            }
                                                                        }}
                                                                    >
                                                                        <SelectTrigger className="h-8 w-fit font-medium first:grow">
                                                                            <SelectValue />
                                                                        </SelectTrigger>
                                                                        <SelectContent className="max-h-[min(26rem,var(--radix-select-content-available-height))]">
                                                                            {props.options?.map((option) => (
                                                                                <SelectItem
                                                                                    key={option.value}
                                                                                    value={String(option.value)}
                                                                                    disabled={option.disabled}
                                                                                >
                                                                                    {option.label}
                                                                                </SelectItem>
                                                                            ))}
                                                                        </SelectContent>
                                                                    </Select>
                                                                )
                                                            },
                                                        }}
                                                    />
                                                </PopoverContent>
                                            </Popover>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="password"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Password</FormLabel>
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
                                    Create Account
                                </Button>
                            </div>
                            <div className="text-center text-sm mt-6">
                                Already have an account?{" "}
                                <Link to="/auth/login" className="text-primary">
                                    Login
                                </Link>
                            </div>
                        </form>
                    </Form>
                </CardContent>
            </Card>
        </div>
    );
};

export default Register;