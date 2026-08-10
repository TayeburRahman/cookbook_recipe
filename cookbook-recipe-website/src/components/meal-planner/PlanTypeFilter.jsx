import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";

// Reusable label formatter
const formatLabel = (rawLabel) => {
    if (!rawLabel) return "Unnamed Plan";

    return rawLabel
        .split(/[_-]/)
        .map(
            (word) =>
                word.length > 0
                    ? word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
                    : ""
        )
        .join(" ");
};

const PlanTypeFilter = ({ title, items, value, onValueChange }) => (
    <Select
        value={value?.label || ""}
        onValueChange={(label) => {
            const selectedItem = items.find(
                (item) => (typeof item === "object" ? item.label : item) === label
            );
            onValueChange(selectedItem);
        }}
    >
        <SelectTrigger className="flex items-center gap-2">
            <SelectValue placeholder={title} />
        </SelectTrigger>

        <SelectContent>
            <div>
                {items.map((item, index) => {
                    const itemValue = typeof item === "object" ? item.label : item;
                    const itemLabel = typeof item === "object" ? item.label : item;

                    return (
                        <SelectItem key={index} value={itemValue}>
                            {formatLabel(itemLabel)}
                        </SelectItem>
                    );
                })}
            </div>
        </SelectContent>
    </Select>
);

export default PlanTypeFilter;