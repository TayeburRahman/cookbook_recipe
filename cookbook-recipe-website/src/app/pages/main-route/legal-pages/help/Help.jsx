import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
import { replaceWhiteBackground } from "@/lib/utils";
import { useGetHelpQuery } from "@/redux/feature/legal/legalApi";
import React from "react";
import LegalSkeleton from "@/components/skeleton/legal/LegalSkeleton";
import Error from "@/components/common/error/Error";
const Help = () => {

    const { data, isLoading, isError } = useGetHelpQuery()
    const help = data?.data?.description
    console.log(help)
    const breadcrumb = [
        { name: 'Home', href: '/' },
        { name: 'Help' },
    ];

    if (isLoading) {
        return <LegalSkeleton />;
    }
    return (
        <div>
            <PageHeader
                breadcrumbs={breadcrumb}
                title="Help"
            />
            <PageLayout paddingSize="compact">
                <div dangerouslySetInnerHTML={{ __html: replaceWhiteBackground(help) }} />
                {isError && <Error msg="Something went wrong" />}
            </PageLayout>
        </div>
    );
};

export default Help;