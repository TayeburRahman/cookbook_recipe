"use client"

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Calendar } from "@/components/ui/calendar";
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { Checkbox } from "@/components/ui/checkbox";
import { CalendarIcon } from "lucide-react";
import { format } from "date-fns";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { cn, ErrorToast, SuccessToast } from "@/lib/utils";
import { useEffect } from "react";
import { useUpdateUserProfileMutation } from "@/redux/feature/profile/profileApi";

const MEAL_TYPES = ['breakfast', 'lunches-and-dinners', 'desserts', 'snacks', 'sides'];
const DIETARY_OPTIONS = ['Gluten-Free', 'Vegan', 'Vegetarian', 'Keto', 'Paleo'];
const HEALTH_GOALS = ['Weight Loss', 'Muscle Gain', 'Maintain Weight'];

const accountSchema = z.object({
    name: z.string().min(1, { message: "Name is required." }),
    email: z.string().email(),
    phone: z.string().min(10, { message: "Phone number must be at least 10 digits." }),
    dateOfBirth: z.date({
        required_error: "A date of birth is required.",
    }).nullable(),
    mail_types: z.array(z.string()).min(1, { message: "Please select at least one meal type." }),
    relevant_dielary: z.array(z.string()).optional(),
    helgth_goal: z.array(z.string()).min(1, { message: "Please select at least one health goal." }),
});


const EditAccount = ({ user, newProfileImage }) => {
    const form = useForm({
        resolver: zodResolver(accountSchema),
        defaultValues: {
            name: "",
            email: "",
            phone: "",
            dateOfBirth: null,
            mail_types: [],
            relevant_dielary: [],
            helgth_goal: [],
        },
    });

    // console.log(user);

    useEffect(() => {
        if (user) {
            const ensureArray = (value) => {
                if (!value) return [];
                if (Array.isArray(value)) return value;
                if (typeof value === 'string') {
                    try {
                        const parsed = JSON.parse(value);
                        return Array.isArray(parsed) ? parsed : [value];
                    } catch (e) {
                        console.log(e);
                        return [value];
                    }
                }
                return [];
            };

            form.reset({
                name: user.name || "",
                email: user.email || "",
                phone: user.phone_number || "",
                dateOfBirth: user.date_of_birth ? new Date(user.date_of_birth) : null,
                mail_types: ensureArray(user.mail_types),
                relevant_dielary: ensureArray(user.relevant_dielary),
                helgth_goal: ensureArray(user.helgth_goal),
            });
        }
    }, [user, form]);

    const [updateUserProfile, { isLoading }] = useUpdateUserProfileMutation();

    const onSubmit = async (data, event) => {
        event.preventDefault();
        const formData = new FormData();

        formData.append("name", data.name);
        formData.append("email", data.email);
        formData.append("phone_number", data.phone);

        if (data.dateOfBirth) {
            formData.append("date_of_birth", format(new Date(data.dateOfBirth), "yyyy-MM-dd"));
        }

        if (data.mail_types && Array.isArray(data.mail_types)) {
            formData.append('mail_types', JSON.stringify(data.mail_types));
        }

        if (data.relevant_dielary && Array.isArray(data.relevant_dielary)) {
            formData.append('relevant_dielary', JSON.stringify(data.relevant_dielary));
        }

        if (data.helgth_goal && Array.isArray(data.helgth_goal)) {
            formData.append('helgth_goal', JSON.stringify(data.helgth_goal));
        }

        if (newProfileImage) {
            formData.append('profile_image', newProfileImage);
        }

        // for (const [key, value] of Object.entries(formData)) {
        //     console.log(key, value);
        // }

        try {
            await updateUserProfile(formData).unwrap();
            SuccessToast("Profile updated successfully");
        } catch (error) {
            ErrorToast("Error updating profile");
            console.log(error);
        }
    };

    return (
        <Card className="py-6 bg-transparent border">
            <CardHeader>
                <CardTitle>Account Information</CardTitle>
                <CardDescription>
                    Update your account information and email address.
                </CardDescription>
            </CardHeader>
            <CardContent>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormField
                                control={form.control}
                                name="name"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Name</FormLabel>
                                        <FormControl>
                                            <Input placeholder="eg: John Doe" {...field} />
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
                                            <Input disabled {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={form.control}
                                name="phone"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Phone Number</FormLabel>
                                        <FormControl>
                                            <Input placeholder="eg: +880123456789" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={form.control}
                                name="dateOfBirth"
                                render={({ field }) => (
                                    <FormItem className="flex flex-col">
                                        <FormLabel>Date of Birth</FormLabel>
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
                                                    className="rounded-md border shadow-sm"
                                                    captionLayout="dropdown"
                                                    disabled={(date) =>
                                                        date > new Date() || date < new Date("1900-01-01")
                                                    }
                                                    defaultMonth={field.value || new Date()}
                                                    fromYear={1900}
                                                    toYear={new Date().getFullYear()}
                                                />
                                            </PopoverContent>
                                        </Popover>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>

                        <FormField
                            control={form.control}
                            name="helgth_goal"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Health Goal</FormLabel>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 p-4 border rounded-md">
                                        {HEALTH_GOALS.map((item) => (
                                            <div key={item} className="flex flex-row items-start space-x-3 space-y-0">
                                                <FormControl>
                                                    <Checkbox
                                                        checked={field.value?.includes(item)}
                                                        onCheckedChange={(checked) => {
                                                            return checked
                                                                ? field.onChange([...(field.value || []), item])
                                                                : field.onChange(
                                                                    field.value?.filter(
                                                                        (value) => value !== item
                                                                    )
                                                                );
                                                        }}
                                                    />
                                                </FormControl>
                                                <FormLabel className="font-normal capitalize">{item.replace(/[-_]/g, ' ')}</FormLabel>
                                            </div>
                                        ))}
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <FormField
                            control={form.control}
                            name="mail_types"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Meal Types</FormLabel>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 p-4 border rounded-md">
                                        {MEAL_TYPES.map((item) => (
                                            <div key={item} className="flex flex-row items-start space-x-3 space-y-0">
                                                <FormControl>
                                                    <Checkbox
                                                        checked={field.value?.includes(item)}
                                                        onCheckedChange={(checked) => {
                                                            return checked
                                                                ? field.onChange([...(field.value || []), item])
                                                                : field.onChange(
                                                                    field.value?.filter(
                                                                        (value) => value !== item
                                                                    )
                                                                );
                                                        }}
                                                    />
                                                </FormControl>
                                                <FormLabel className="font-normal capitalize">{item.replace(/[-_]/g, ' ')}</FormLabel>
                                            </div>
                                        ))}
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <FormField
                            control={form.control}
                            name="relevant_dielary"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Dietary Preferences</FormLabel>
                                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 p-4 border rounded-md">
                                        {DIETARY_OPTIONS.map((item) => (
                                            <div key={item} className="flex flex-row items-start space-x-3 space-y-0">
                                                <FormControl>
                                                    <Checkbox
                                                        checked={field.value?.includes(item)}
                                                        onCheckedChange={(checked) => {
                                                            return checked
                                                                ? field.onChange([...(field.value || []), item])
                                                                : field.onChange(
                                                                    field.value?.filter(
                                                                        (value) => value !== item
                                                                    )
                                                                );
                                                        }}
                                                    />
                                                </FormControl>
                                                <FormLabel className="font-normal capitalize">{item.replace(/[-_]/g, ' ')}</FormLabel>
                                            </div>
                                        ))}
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <div className="flex justify-end">
                            <Button loading={isLoading} type="submit">Save Changes</Button>
                        </div>
                    </form>
                </Form>
            </CardContent>
        </Card>
    );
};

export default EditAccount;
