import { cn } from "@/lib/utils";

const Error = ({ msg, size = "sm", className }) => {
  const heightMap = {
    sm: "h-[calc(100vh-450px)]",
    perfect: "h-[calc(100vh-340px)]",
    full: "h-[calc(100vh-248px)]",
  };

  return (
    <div className={cn("flex items-center justify-center col-span-full", heightMap[size], className)}>
      <p className="text-red-500 text-center text-sm md:text-base px-4">
        {msg}
      </p>
    </div>
  );
};

export default Error;