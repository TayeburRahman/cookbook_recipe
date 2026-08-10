import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
import LegalSkeleton from "@/components/skeleton/legal/LegalSkeleton";
import Error from "@/components/common/error/Error";
import { replaceWhiteBackground } from "@/lib/utils";
import { useGetPrivacyPolicyQuery } from "@/redux/feature/legal/legalApi";

const Privacy = () => {
    const { data, isLoading, isError } = useGetPrivacyPolicyQuery()
    const privacy = data?.data?.description

    const breadcrumb = [
        { name: 'Home', href: '/' },
        { name: 'Privacy' },
    ];

    if (isLoading) {
        return <LegalSkeleton />;
    }
    return (
        <div>
            <PageHeader
                breadcrumbs={breadcrumb}
                title="Privacy"
            />
            <PageLayout paddingSize="compact">
                <div dangerouslySetInnerHTML={{ __html: replaceWhiteBackground(privacy) }} />
                {isError && <Error msg="Something went wrong" />}
            </PageLayout>
        </div>
    );
};

export default Privacy;