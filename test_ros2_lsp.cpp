#include <rclcpp/rclcpp.hpp>
#include <rclcpp_lifecycle/lifecycle_node.hpp>
#include <lifecycle_msgs/msg/state.hpp>
#include <lifecycle_msgs/msg/transition.hpp>
#include <std_msgs/msg/string.hpp>
#include <geometry_msgs/msg/twist.hpp>

using namespace std::chrono_literals;

class TestLifecycleNode : public rclcpp_lifecycle::LifecycleNode
{
public:
    TestLifecycleNode() : LifecycleNode("test_lifecycle_node")
    {
        RCLCPP_INFO(this->get_logger(), "TestLifecycleNode created");
    }

    rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
    on_configure(const rclcpp_lifecycle::State &)
    {
        RCLCPP_INFO(this->get_logger(), "Configuring");

        // 创建发布者
        pub_ = this->create_publisher<std_msgs::msg::String>("test_topic", 10);
        twist_pub_ = this->create_publisher<geometry_msgs::msg::Twist>("cmd_vel", 10);

        // 创建定时器
        timer_ = this->create_wall_timer(
            500ms, std::bind(&TestLifecycleNode::timer_callback, this));

        return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
    }

    rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
    on_activate(const rclcpp_lifecycle::State &)
    {
        RCLCPP_INFO(this->get_logger(), "Activating");
        return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
    }

    rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
    on_deactivate(const rclcpp_lifecycle::State &)
    {
        RCLCPP_INFO(this->get_logger(), "Deactivating");
        return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
    }

    rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
    on_cleanup(const rclcpp_lifecycle::State &)
    {
        RCLCPP_INFO(this->get_logger(), "Cleaning up");
        pub_.reset();
        twist_pub_.reset();
        timer_.reset();
        return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
    }

    rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn
    on_shutdown(const rclcpp_lifecycle::State &)
    {
        RCLCPP_INFO(this->get_logger(), "Shutting down");
        return rclcpp_lifecycle::node_interfaces::LifecycleNodeInterface::CallbackReturn::SUCCESS;
    }

private:
    void timer_callback()
    {
        auto msg = std_msgs::msg::String();
        msg.data = "Hello from lifecycle node: " + std::to_string(count_++);

        auto twist = geometry_msgs::msg::Twist();
        twist.linear.x = 0.5;
        twist.angular.z = 0.1;

        if (this->get_current_state().id() == lifecycle_msgs::msg::State::PRIMARY_STATE_ACTIVE) {
            pub_->publish(msg);
            twist_pub_->publish(twist);
            RCLCPP_INFO(this->get_logger(), "Publishing: %s", msg.data.c_str());
        }
    }

    std::shared_ptr<rclcpp::Publisher<std_msgs::msg::String>> pub_;
    std::shared_ptr<rclcpp::Publisher<geometry_msgs::msg::Twist>> twist_pub_;
    std::shared_ptr<rclcpp::TimerBase> timer_;
    size_t count_ = 0;
};

int main(int argc, char ** argv)
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<TestLifecycleNode>();

    rclcpp::executors::SingleThreadedExecutor executor;
    executor.add_node(node->get_node_base_interface());

    executor.spin();

    rclcpp::shutdown();
    return 0;
}