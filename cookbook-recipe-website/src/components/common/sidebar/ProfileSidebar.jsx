import { NavLink } from 'react-router-dom';
import { User, Heart, Book, ChevronRight, Plus } from 'lucide-react';

const sidebarNavLinks = [
    { to: '/profile', icon: <User size={16} />, label: 'My Account', end: true },
    { to: '/profile/my-favourite', icon: <Heart size={16} />, label: 'My Favourite' },
    { to: '/profile/my-recipes', icon: <Book size={16} />, label: 'My Recipe' },
    { to: '/profile/add-recipe', icon: <Plus size={16} />, label: 'Add Recipe' },
];


const ProfileSidebar = () => {
    return (
        <div className="rounded-lg h-full border max-h-[calc(100vh-280px)] p-6 bg-background">
            <h2 className="text-xl font-bold mb-6 text-foreground">Account & Orders</h2>

            <nav className="space-y-1">
                {sidebarNavLinks.map((link) => (
                    <NavLink
                        key={link.to}
                        to={link.to}
                        end={link.end}
                        className={({ isActive }) =>
                            `flex items-center justify-between p-3 rounded-md border-l-4 transition-colors text-sm ${isActive
                                ? 'bg-muted border-primary text-foreground font-semibold'
                                : 'border-transparent text-muted-foreground hover:bg-muted'
                            }`
                        }
                    >
                        <div className="flex items-center gap-2">
                            {link.icon}
                            <span>{link.label}</span>
                        </div>
                        <ChevronRight size={16} />
                    </NavLink>
                ))}
            </nav>
        </div>
    );
};

export default ProfileSidebar;