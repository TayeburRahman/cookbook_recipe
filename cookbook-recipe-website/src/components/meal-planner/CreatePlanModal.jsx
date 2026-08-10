import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
    DialogClose,
    DialogDescription,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import { useCreateCustomMealPlanMutation } from "@/redux/feature/meal-plan/mealPlanApi";

const CreatePlanModal = ({ isOpen, setIsOpen }) => {
    const [planName, setPlanName] = useState("");
    const [createCustomMealPlan, { isLoading }] = useCreateCustomMealPlanMutation();

    const handleCreate = async () => {
        if (!planName.trim()) return;
        try {
            await createCustomMealPlan({ name: planName }).unwrap();
            setPlanName("");
            setIsOpen(false);
        } catch (error) {
            console.error("Failed to create custom meal plan", error);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={setIsOpen}>
            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle>Create Custom Meal Plan</DialogTitle>
                    <DialogDescription>
                        Enter a name for your custom meal plan.
                    </DialogDescription>
                </DialogHeader>
                <div className="py-4">
                    <Input
                        placeholder="Enter plan name"
                        value={planName}
                        onChange={(e) => setPlanName(e.target.value)}
                    />
                </div>
                <DialogFooter>
                    <DialogClose asChild>
                        <Button variant="outline">Cancel</Button>
                    </DialogClose>
                    <Button onClick={handleCreate} disabled={isLoading || !planName.trim()}>
                        {isLoading ? "Creating..." : "Create"}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};

export default CreatePlanModal;