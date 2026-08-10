import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/ui/accordion";
import { useGetFaqQuery } from "@/redux/feature/legal/legalApi";
import { Link } from "react-router-dom";

const Faq = () => {
    const { data: faqs } = useGetFaqQuery()

    const breadcrumb = [
        { name: 'Home', href: '/' },
        { name: 'FAQs' },
    ]
    return (
        <>
            <PageHeader
                breadcrumbs={breadcrumb}
                title="FAQs"
            />
            <PageLayout paddingSize="compact">
                <div className="mb-8 flex flex-col justify-center items-center">
                    <h2 className="text-xl md:text-2xl text-title font-medium mb-2">Welcome to our FAQ section!</h2>
                    <p className="text-subtitle text-sm max-w-3xl text-center">Here,  find answers to common questions about orders, shipping and returns. If you need further assistance, feel free to <Link className="underline text-blue-600" to="/contact">contact us</Link>   .</p>
                </div>
                {/* Accordion */}
                <div className="max-w-4xl mx-auto">
                    <Accordion
                        type="single"
                        collapsible
                        className="w-full space-y-2"
                    >
                        {faqs?.data?.map((item, index) => (
                            <AccordionItem
                                value={`item-${index}`}
                                key={index}
                                className="bg-background has-focus-visible:border-ring has-focus-visible:ring-ring/50 rounded-md border p-4 outline-none last:border-b has-focus-visible:ring-[3px]"
                            >
                                <AccordionTrigger className="py-2 text-[15px] leading-6 hover:no-underline focus-visible:ring-0">
                                    {item.questions}
                                </AccordionTrigger>
                                <AccordionContent className="text-muted-foreground pb-2">
                                    {item.answer}
                                </AccordionContent>
                            </AccordionItem>
                        ))}
                    </Accordion>
                </div>
            </PageLayout>
        </>
    );
};

export default Faq;