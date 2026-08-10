import React from 'react';
import { Link } from 'react-router-dom';
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";

/**
 * A reusable page header component with a title and breadcrumbs.
 * @param {{ title: string, breadcrumbs: { name: string, href?: string }[] }} props
 */
const PageHeader = ({ title, breadcrumbs }) => {
  return (
    <section className="bg-secondary py-6 md:py-12">
      <div className="container max-w-7xl mx-auto text-center">
        <h1 className="text-2xl md:text-3xl font-semibold mb-4">{title}</h1>
        <Breadcrumb>
          <BreadcrumbList className="justify-center">
            {breadcrumbs.map((crumb, index) => (
              <React.Fragment key={index}>
                <BreadcrumbItem>
                  {crumb.href ? (
                    <BreadcrumbLink asChild>
                      <Link to={crumb.href}>{crumb.name}</Link>
                    </BreadcrumbLink>
                  ) : (
                    <BreadcrumbPage className="">{crumb.name}</BreadcrumbPage>
                  )}
                </BreadcrumbItem>
                {index < breadcrumbs.length - 1 && <BreadcrumbSeparator />}
              </React.Fragment>
            ))}
          </BreadcrumbList>
        </Breadcrumb>
      </div>
    </section>
  );
};

export default PageHeader;