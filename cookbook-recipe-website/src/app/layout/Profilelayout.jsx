import { Outlet, ScrollRestoration } from 'react-router-dom';
import PageHeader from '@/components/common/page-header/PageHeader';
import ProfileSidebar from '@/components/common/sidebar/ProfileSidebar';
import WarningModal from '@/components/common/modal/WarningModal';

const Profilelayout = () => {
    const breadcrumbs = [
        { name: 'Home', href: '/' },
        { name: 'Profile' },
    ];
    return (
        <>
            <WarningModal />
            <div className='body-height'>
                <PageHeader
                    title="My Profile"
                    breadcrumbs={breadcrumbs}
                />
                <div className="container max-w-7xl mx-auto py-4 px-4 xl:px-0">
                    <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
                        {/* Desktop Sidebar */}
                        <div className="hidden md:block md:col-span-5 lg:col-span-4 col-span-12">
                            <ProfileSidebar />
                        </div>

                        {/* Main Content */}
                        <div className="md:col-span-7 lg:col-span-8 col-span-12 border p-4 rounded-lg">
                            <Outlet />
                        </div>
                    </div>
                </div>
            </div>
            <ScrollRestoration />
        </>
    );
};

export default Profilelayout;
