import PageLayout from "@/tools/PageLayout";
import Error from "@/components/common/error/Error";
import PageHeader from "@/components/common/page-header/PageHeader";
import LegalSkeleton from "@/components/skeleton/legal/LegalSkeleton";
import { replaceWhiteBackground } from "@/lib/utils";
import { useGetAboutQuery } from "@/redux/feature/legal/legalApi";

const About = () => {
    const { data, isLoading, isError } = useGetAboutQuery()
    const about = data?.data?.description

    if (isLoading) {
        return <LegalSkeleton />;
    }
    const breadcrumb = [
        { name: 'Home', href: '/' },
        { name: 'About' },
    ];
    return (
        <div>
            <PageHeader
                breadcrumbs={breadcrumb}
                title="About"
            />
            <PageLayout paddingSize="compact">
                <div dangerouslySetInnerHTML={{ __html: replaceWhiteBackground(about) }} />
                {isError && <Error msg="Something went wrong" />}
            </PageLayout>
        </div>
    );
};

export default About;