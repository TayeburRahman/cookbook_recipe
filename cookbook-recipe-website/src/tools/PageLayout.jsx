import { cn } from "@/lib/utils";

const PageLayout = ({ children, pagination, className, paddingSize = "default" }) => {
  const paddingMap = {
    default: "px-4 py-12 lg:py-18 xl:px-0",
    compact: "px-4 pt-5 pb-12 lg:pb-18 xl:px-0 min-h-[calc(100vh-248px)] relative",
    none: "px-4 xl:px-0 py-5",
  };

  return (
    <div className={cn("container max-w-7xl mx-auto", paddingMap[paddingSize], className)}>
      <div className="flex-grow mb-4 lg:mb-0">
        {children}
      </div>
      {pagination}
    </div>
  );
};

export default PageLayout;