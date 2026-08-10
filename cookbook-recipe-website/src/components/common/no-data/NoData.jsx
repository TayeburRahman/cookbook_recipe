import { cn } from "@/lib/utils";

const NoData = ({ msg, size = "sm", className, children }) => {
  const heightMap = {
    noHeight: "",
    sm: "h-[calc(100vh-450px)]",
    perfect: "h-[calc(100vh-340px)]",
    full: "h-[calc(100vh-248px)]",
  };

  return (
    <div className={cn("flex flex-col items-center justify-center col-span-full", heightMap[size], className)}>
      <p className="text-muted-foreground text-center text-sm md:text-base px-4">
        {msg}
      </p>
      {children}
    </div>
  );
};

export default NoData;