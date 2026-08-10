import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogDescription,
    DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { useSelector, useDispatch } from "react-redux";
import { SetWarningModal } from "@/redux/feature/auth/authSlice";

const WarningModal = () => {
    const { warningModal } = useSelector((state) => state.auth);
    const dispatch = useDispatch();

    const handleClose = () => {
        dispatch(SetWarningModal(false));
        sessionStorage.removeItem("showWarningModal");
    };

    return (
        <Dialog open={warningModal} onOpenChange={handleClose}>
            <DialogContent className="sm:max-w-xl">
                <DialogHeader>
                    <DialogTitle>Update Your Profile</DialogTitle>
                    <DialogDescription>
                        Please update your profile with your meal type and dietary preferences to get personalized recommendations.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button onClick={handleClose}>Okay</Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};

export default WarningModal;
